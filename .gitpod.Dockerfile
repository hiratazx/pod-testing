# Use Ubuntu 24.04 as the base image
FROM ubuntu:24.04

# Set non-interactive mode for apt-get
ENV DEBIAN_FRONTEND=noninteractive

# Update and install sudo first
RUN apt-get update && \
    apt-get install -y sudo

# Install other necessary packages
RUN apt-get install -y git bash build-essential flex bc \
    bison cpio gcc xmlstarlet xattr acl aria2 wget curl

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

RUN echo 'if [ "$USER" == "gitpod" ] && [[ $- == *i* ]]; then sleep 5 && /usr/local/bin/change_user.sh; fi' >> /home/gitpod/.bash_profile

RUN sudo wget -O /usr/local/bin/change_user.sh https://raw.githubusercontent.com/hiratazx/pod-testing/refs/heads/main/change_user.sh

RUN sudo chmod a+x /usr/local/bin/change_user.sh

# Switch back to the gitpod user to allow normal operations in Gitpod
USER gitpod

# Set default working directory
WORKDIR /workspace
