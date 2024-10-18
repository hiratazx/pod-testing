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
    useradd -m -s /bin/bash brokenedtz && \
    useradd -m -s /bin/bash gitpod

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

# Switch back to the gitpod user to allow normal operations in Gitpod
USER gitpod

# Set the custom hostname when a new bash session starts
RUN echo "yukiprjkt-pod" >> /etc/bash.bashrc

# Set default working directory
WORKDIR /workspace
