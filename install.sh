#!/bin/bash

# Change directory to $[HOME]
pushd ${HOME}

# Crate a password for the user
sudo passwd ${USER}

# Install Homebrew
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Set brew in shell
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Install everything within the Brewfile
brew bundle
brew install --cask font-fira-code-nerd-font

# Set zsh as the default shell for the ${USER}
echo "Settign zsh as default shell for ${USER_SCRIPT}"
command -v zsh | tee -a /etc/shells
chsh -s "$(command -v zsh)" ${USER_SCRIPT}

# Start the containers
pushd ${HOME}/docker-compose
docker compose up -d

# Reboot the system
sudo poweroff --reboot