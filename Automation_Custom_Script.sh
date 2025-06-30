#!/bin/bash

USER_SCRIPT="tim"
HOME_USER="/home/${USER_SCRIPT}"

HTTPS_REPO="https://github.com/timothymamo/dietpi-post-install.git"

# Create super user with no password
adduser --disabled-password --gecos "" ${USER_SCRIPT}
usermod -aG sudo ${USER_SCRIPT}
passwd -d ${USER_SCRIPT}

# Copy the .ssh directory
cp -r /root/.ssh/ ${HOME_USER}

# install build-essentials
apt-get install build-essential -y

# Disable root ssh login
sed -i '/#PermitRootLogin prohibit-password/c\PermitRootLogin no' /etc/ssh/sshd_config

# Create a git directory and clone this repo
mkdir -p ${HOME_USER}/git/dietpi-post-install/
git clone ${HTTPS_REPO} ${HOME_USER}/git/dietpi-post-install/

# Create symlinks for all files
ln -s ${HOME_USER}/git/dietpi-post-install/* ${HOME_USER}
ln -s ${HOME_USER}/git/dietpi-post-install/.* ${HOME_USER}

# Remove .git dierctory so any changes within ${HOME} don't get pushed to the repo
rm -rf ${HOME_USER}/.git

# Set zsh as the default shell for the ${USER}
command -v zsh | tee -a /etc/shells
chsh -s "$(command -v zsh)" ${USER_SCRIPT}

# Restart sshd
systemctl restart sshd

# Setup Docker to have the appropriate permissions and restart
usermod -aG docker ${USER_SCRIPT}
systemctl enable docker

chown -R ${USER_SCRIPT}:${USER_SCRIPT} ${HOME_USER}