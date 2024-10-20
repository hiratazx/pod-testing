# Use Ubuntu 24.04 as the base image
FROM ubuntu:24.04

# Set non-interactive mode for apt-get
ENV DEBIAN_FRONTEND=noninteractive

# Update and install sudo first
RUN apt-get update && \
    apt-get install -y sudo

# Install other necessary packages
RUN apt-get install -y git bash build-essential flex bc \
    bison cpio gcc xmlstarlet xattr acl aria2 wget curl nano libssl-dev lz4 python-is-python3 g++ make htop bmon sysstat git llvm rustc cargo openjdk-21-jdk gradle rsync rclone

RUN apt-get install -y --fix-missing ccache jq openssh-server screen python3 python-is-python3 \
    git git-lfs android-tools-adb bc bison build-essential curl flex gh g++-multilib gcc-multilib gnupg \
    gperf imagemagick lib32ncurses-dev lib32readline-dev lib32z1-dev liblz4-tool libncurses5-dev libsdl1.2-dev libssl-dev \
    libxml2 libxml2-utils lzop pngcrush rsync schedtool squashfs-tools xsltproc yasm zip zlib1g-dev \
    mosh tmux xattr nano wget locales ncdu zsh rclone w3m neofetch htop bmon ripgrep zoxide neovim vim zsh duf aria2 

RUN curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | sudo bash && apt-get install -y speedtest-cli

RUN wget -O rustup-init.sh https://sh.rustup.rs

RUN bash rustup-init.sh -y

RUN rm -rf rustup-init.sh

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

RUN ln -s /workspace/pod-testing/itzkaguya /home/itzkaguya/storage-itzkaguya
RUN ln -s /workspace/pod-testing/renelzx /home/renelzx/storage-renelzx
RUN ln -s /workspace/pod-testing/rsuntk /home/rsuntk/storage-rsuntk
RUN ln -s /workspace/pod-testing/brokenedtz /home/brokenedtz/storage-brokenedtz

RUN echo "alias container-stop='gp stop'" >> /etc/bash.bashrc

RUN echo "clear" >> /etc/bash.bashrc

RUN sudo wget -O /usr/local/bin/change_user.sh https://raw.githubusercontent.com/hiratazx/pod-testing/refs/heads/main/change_user.sh

RUN sudo chmod a+x /usr/local/bin/change_user.sh

RUN sudo wget -O /usr/local/bin/yukiprjkt https://warehouse.itzkaguya.my.id/d/guest/yukiprjkt-bin?sign=Ju4WDpYOpts9wPikaFshGu3YnbwLoS_j1mCs9fcmKMI=:0

RUN sudo chmod a+x /usr/local/bin/yukiprjkt

COPY android.sh ./
RUN chmod a+x ./android.sh
RUN ./android.sh
RUN rm ./android.sh

# Switch back to the gitpod user to allow normal operations in Gitpod
USER gitpod

# Set default working directory
WORKDIR /workspace
