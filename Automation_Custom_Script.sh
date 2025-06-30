#!/bin/bash

# adduser --disabled-password --gecos "" tim
# usermod -aG sudo tim
# passwd -d tim

# cp -r /root/.ssh/ /home/tim
# chown -R tim:tim /home/tim/.ssh

# echo 'tim ALL=(ALL:ALL) ALL' >> /etc/sudoers

# # Change User
# su tim

# Change directory to $[HOME]
cd ${HOME}

#Install Homebrew
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
sudo apt-get install build-essential -y

# Create a git directory and clone this repo
#mkdir git
#git clone https://github.com/timothymamo/dietpi-post-install.git "${HOME}/git/dietpi-post-install/"

# Set brew in shell
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Create symlinks for all files apart from the .git directory
ln -s ${HOME}/git/dietpi-post-install/* ${HOME}
ln -s ${HOME}/git/dietpi-post-install/.* ${HOME}

# Remove symlinks for .git and .env inbthe ${HOME} directory so any changes within ${HOME} don't get pushed to the repo
rm -rf ${HOME}/.git ${HOME}/docker-compose/.env

# Copy the .env file to the ${HOME} directory - this will be modified later but is needed to run docker compose
cp ${HOME}/git/dietpi-post-install/ ${HOME}/docker-compose/.env

# Install everything with the Brewfile
brew bundle

brew install --cask font-fira-code-nerd-font

# Set zsh as the default shell for the ${USER}
command -v zsh | sudo tee -a /etc/shells
sudo chsh -s "$(command -v zsh)" ${USER}

# Disable root ssh login
sudo sed -i '/#PermitRootLogin prohibit-password/c\PermitRootLogin no' /etc/ssh/sshd_config

# Restart sshd
sudo systemctl restart sshd

# Setup Docker to have the appropriate permissions
sudo usermod -aG docker ${USER}
newgrp docker
sudo systemctl enable docker
cd docker-compose
docker compose up -d

# Wait for 2 minutes before rebooting the system
sleep 120
sudo poweroff --reboot