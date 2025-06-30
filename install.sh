#!/bin/bash

# Change directory to $[HOME]
pushd ${HOME}

# Crate a password for the user
passwd ${USER}

# Install Homebrew
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Set brew in shell
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Install everything within the Brewfile
brew bundle
brew install --cask font-fira-code-nerd-font

# Start the containers
pushd ${HOME}/docker-compose
docker compose up -d

# Wait for 2 minutes before rebooting the system
sleep 120
sudo poweroff --reboot