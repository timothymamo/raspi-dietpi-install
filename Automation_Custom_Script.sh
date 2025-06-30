#!/bin/bash

adduser --disabled-password --gecos "" tim
usermod -aG sudo tim
passwd -d tim

cp -r /root/.ssh/ /home/tim
chown -R tim:tim /home/tim/.ssh

echo 'tim ALL=(ALL:ALL) ALL' >> /etc/sudoers