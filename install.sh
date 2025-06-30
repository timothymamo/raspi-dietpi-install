#!/bin/bash

# Change directory to $[HOME]
pushd ${HOME}

# Install Homebrew
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Set brew in shell
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Install everything with the Brewfile
brew bundle

brew install --cask font-fira-code-nerd-font

# Set zsh as the default shell for the ${USER}
command -v zsh | sudo tee -a /etc/shells
sudo chsh -s "$(command -v zsh)" ${USER}

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