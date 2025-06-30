#!/bin/bash

# Change directory to $[HOME]
pushd ${HOME}

# Install Homebrew
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
sudo apt-get install build-essential -y

# Set brew in shell
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Create symlinks for all files apart from the .git directory
ln -s ${HOME}/git/dietpi-post-install/* ${HOME}
ln -s ${HOME}/git/dietpi-post-install/.* ${HOME}

# Remove symlinks for .git and .env inbthe ${HOME} directory so any changes within ${HOME} don't get pushed to the repo
rm -rf ${HOME}/.git ${HOME}/docker-compose/.env

# Copy the .env file to the ${HOME} directory - this will be modified later but is needed to run docker compose
cp -r ${HOME}/git/dietpi-post-install/docker-compose/.env ${HOME}/docker-compose/.env

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
sudo systemctl enable docker
pushd ${HOME}/docker-compose
docker compose up -d

# Wait for 2 minutes before rebooting the system
sleep 120
sudo poweroff --reboot