#!/bin/bash

# Change directory to $[HOME]
cd $[HOME]

# Create a key for user tim
ssh-keygen -a 100 -t ed25519 -f ~/.ssh/id_ed25519 -C "${USER}@${HOSTNAME}"

# Log into Github and copy the public key of the generated ssh file into Settings > SSH and GPG keys > New SSH Key.
cat /home/${USER}/.ssh/id_ed25519.pub

#Install Homebrew
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
sudo apt-get install build-essential -y

# Create a git directory and clone this repo
mkdir git && cd git
git clone git@github.com:timothymamo/dietpi-post-install.git

# Set brew in shell
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Create symlinks for all files apart from the .git directory
ln -s /home/${USER}/git/dietpi-post-install/* .
ln -s /home/${USER}/git/dietpi-post-install/.* .
rm -rf .git

# Install everything with the Brewfile
brew bundle

brew install --cask font-fira-code-nerd-font

# Set zsh as the default shell for the ${USER}
command -v zsh | sudo tee -a /etc/shells
sudo chsh -s "$(command -v zsh)" "${USER}"

# Disable root ssh login
sed -i '/#PermitRootLogin prohibit-password/c\PermitRootLogin no' /etc/ssh/sshd_config

# Restart sshd
sudo systemctl restart sshd

# Setup Docker to have the appropriate permissions
sudo usermod -aG docker ${USER}
newgrp docker
sudo systemctl enable docker
cd docker-compose
docker compose up -d