#!/bin/bash

adduser --disabled-password --gecos "" tim
usermod -aG sudo tim
passwd -d tim

cp -r /root/.ssh/ /home/tim
chown -R tim:tim /home/tim/.ssh

echo 'tim ALL=(ALL:ALL) ALL' >> /etc/sudoers

# Disable root ssh login
sed -i '/#PermitRootLogin prohibit-password/c\PermitRootLogin no' /etc/ssh/sshd_config

# Create a git directory and clone this repo
mkdir -p /home/tim/git/dietpi-post-install/
git clone https://github.com/timothymamo/dietpi-post-install.git /home/tim/git/dietpi-post-install/