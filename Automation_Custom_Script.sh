#!/bin/bash

adduser --disabled-password --gecos "" tim
usermod -aG sudo tim
passwd -d tim

cp -r /root/.ssh/ /home/tim
chown -R tim:tim /home/tim/.ssh

echo 'tim ALL=(ALL:ALL) ALL' >> /etc/sudoers

apt-get install build-essential -y

# Disable root ssh login
sed -i '/#PermitRootLogin prohibit-password/c\PermitRootLogin no' /etc/ssh/sshd_config

HOME_TIM='/home/tim'

# Create a git directory and clone this repo
mkdir -p /home/tim/git/dietpi-post-install/
git clone https://github.com/timothymamo/dietpi-post-install.git ${HOME_TIM}/git/dietpi-post-install/

# Create symlinks for all files apart from the .git directory
ln -s ${HOME_TIM}/git/dietpi-post-install/* ${HOME_TIM}
ln -s ${HOME_TIM}/git/dietpi-post-install/.* ${HOME_TIM}

# Remove symlinks for .git and .env inbthe ${HOME} directory so any changes within ${HOME} don't get pushed to the repo
rm -rf ${HOME_TIM}/.git ${HOME_TIM}/docker-compose/.env

# Copy the .env file to the ${HOME} directory - this will be modified later but is needed to run docker compose
cp -r ${HOME_TIM}/git/dietpi-post-install/docker-compose/.env ${HOME_TIM}/docker-compose/.env

chown -R tim:tim /home/tim