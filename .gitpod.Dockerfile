# Use Ubuntu 24.04 as the base image
FROM ubuntu:24.04

# Set non-interactive mode for apt-get
ENV DEBIAN_FRONTEND=noninteractive

# Update and install sudo first
RUN apt-get update && \
    apt-get install -y sudo

# Install other necessary packages
RUN apt-get install -y git bash build-essential flex bc \
    bison cpio gcc xmlstarlet xattr acl

# Create users with no passwords and default shell as bash
RUN useradd -m -s /bin/bash itzkaguya && \
    useradd -m -s /bin/bash renelzx && \
    useradd -m -s /bin/bash rsuntk && \
    useradd -m -s /bin/bash brokenedtz

# Add users to sudo group and configure sudoers
RUN usermod -aG sudo itzkaguya && \
    usermod -aG sudo renelzx && \
    usermod -aG sudo rsuntk && \
    usermod -aG sudo brokenedtz && \
    echo "itzkaguya ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    echo "renelzx ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    echo "rsuntk ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    echo "brokenedtz ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    echo "gitpod ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN groupmod -g 33333 gitpod || groupadd -g 33333 gitpod && \
    usermod -u 33333 -g 33333 gitpod || useradd -u 33333 -g 33333 -m -s /bin/bash gitpod

RUN mkdir -p /workspace/pod-testing/itzkaguya
RUN mkdir -p /workspace/pod-testing/renelzx
RUN mkdir -p /workspace/pod-testing/rsuntk
RUN mkdir -p /workspace/pod-testing/brokenedtz

RUN ln -s /workspace/pod-testing/itzkaguya /home/rsuntk/storage-itzkaguya
RUN ln -s /workspace/pod-testing/renelzx /home/rsuntk/storage-renelzx
RUN ln -s /workspace/pod-testing/rsuntk /home/rsuntk/storage-rsuntk
RUN ln -s /workspace/pod-testing/brokenedtz /home/rsuntk/storage-brokenedtz

RUN echo "alias container-stop='gp stop'" >> /etc/bash.bashrc

RUN echo "clear" >> /etc/bash.bashrc

RUN echo 'if [ "$USER" == "gitpod" ]; then /usr/local/bin/change_user.sh; fi' >> /home/gitpod/.bashrc

RUN echo '#!/bin/bash\n\
users=("itzkaguya" "renelzx" "rsuntk" "brokenedtz")\n\
length=${#users[@]}\n\
display_menu() {\n\
    clear\n\
    echo "Select a user to switch (use Up/Down arrow keys and Enter):"\n\
    for i in "${!users[@]}"; do\n\
        if [ "$i" -eq "$selected" ]; then\n\
            echo -e "\e[1;32m> ${users[$i]}\e[0m"\n\
        else\n\
            echo "  ${users[$i]}"\n\
        fi\n\
    done\n\
}\n\
selected=0\n\
while true; do\n\
    display_menu\n\
    read -rsn3 key\n\
    case "$key" in\n\
        $'\''\x1b[A'\'')\n\
            if [ "$selected" -gt 0 ]; then\n\
                ((selected--))\n\
            else\n\
                selected=$((length - 1))\n\
            fi\n\
            ;;\n\
        $'\''\x1b[B'\'')\n\
            if [ "$selected" -lt $((length - 1)) ]; then\n\
                ((selected++))\n\
            else\n\
                selected=0\n\
            fi\n\
            ;;\n\
        "")\n\
            chosen_user="${users[$selected]}"\n\
            echo "Switching to user: $chosen_user"\n\
            sudo -u "$chosen_user" -i\n\
            exit\n\
            ;;\n\
    esac\n\
done\n' > /usr/local/bin/change_user.sh && chmod +x /usr/local/bin/change_user.sh

# Switch back to the gitpod user to allow normal operations in Gitpod
USER gitpod

# Set default working directory
WORKDIR /workspace
