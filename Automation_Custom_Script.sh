#!/bin/bash

# Set varibales"
USER_SCRIPT="tim"
HTTPS_REPO="https://github.com/timothymamo/dietpi-post-install.git"

HOME_USER="/home/${USER_SCRIPT}"

# Output variables
echo "Creating User: ${USER_SCRIPT}"
echo "Home directory for ${USER_SCRIPT}: ${HOME_USER}"
echo "Repo to clone: ${HTTPS_REPO}"

# Create super user with no password
adduser --disabled-password --gecos "" ${USER_SCRIPT}
usermod -aG sudo ${USER_SCRIPT}
passwd -d ${USER_SCRIPT}

# Copy the .ssh directory
echo "Copying SSH keys"
cp -r /root/.ssh/ ${HOME_USER}

# install build-essentials
echo "Installing Build Essentials"
apt-get install build-essential -y

# Disable root ssh login
echo "Disabling Root login"
sed -i '/#PermitRootLogin prohibit-password/c\PermitRootLogin no' /etc/ssh/sshd_config

# Create a git directory and clone this repo
echo "Clone repo into ${HOME_USER}/git/dietpi-post-install/"
mkdir -p ${HOME_USER}/git/dietpi-post-install/
git clone ${HTTPS_REPO} ${HOME_USER}/git/dietpi-post-install/

# Create symlinks for all files
echo "Symlinking repo into ${HOME_USER}"
ln -s ${HOME_USER}/git/dietpi-post-install/* ${HOME_USER}
ln -s ${HOME_USER}/git/dietpi-post-install/.* ${HOME_USER}

# Remove .git dierctory so any changes within ${HOME} don't get pushed to the repo
echo "Symlinking .git directory within ${HOME_USER}"
rm -rf ${HOME_USER}/.git

# Set zsh as the default shell for the ${USER}
echo "Settign zsh as default shell for ${USER_SCRIPT}"
command -v zsh | tee -a /etc/shells
chsh -s "$(command -v zsh)" ${USER_SCRIPT}

# Restart sshd
echo "Restarting sshd"
systemctl restart sshd

# Setup Docker to have the appropriate permissions and restart
echo "Setting up Docker user and permissions"
usermod -aG docker ${USER_SCRIPT}
systemctl enable docker

echo "Ensuring ownership of ${HOME_USER} is set to ${USER_SCRIPT}"
chown -R ${USER_SCRIPT}:${USER_SCRIPT} ${HOME_USER}