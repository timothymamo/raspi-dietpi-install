#!/bin/bash

adduser --disabled-password --gecos "" tim
usermod -aG sudo tim
passwd -d tim

cp -r /root/.ssh/ /home/tim
chown -R tim:tim /home/tim/.ssh

echo 'tim ALL=(ALL:ALL) ALL' >> /etc/sudoers

HOME_TIM='/home/tim'

echo "Got here"
su tim
echo "Got here 2"

# Change directory to $[HOME]
pushd ${HOME_TIM}

# Install Homebrew
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
sudo apt-get install build-essential -y

# Create a git directory and clone this repo
mkdir git
git clone https://github.com/timothymamo/dietpi-post-install.git "${HOME_TIM}/git/dietpi-post-install/"

# Set brew in shell
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Create symlinks for all files apart from the .git directory
ln -s ${HOME_TIM}/git/dietpi-post-install/* ${HOME_TIM}
ln -s ${HOME_TIM}/git/dietpi-post-install/.* ${HOME_TIM}

# Remove symlinks for .git and .env inbthe ${HOME_TIM} directory so any changes within ${HOME_TIM} don't get pushed to the repo
rm -rf ${HOME_TIM}/.git ${HOME_TIM}/docker-compose/.env

# Copy the .env file to the ${HOME_TIM} directory - this will be modified later but is needed to run docker compose
cp -r ${HOME_TIM}/git/dietpi-post-install/docker-compose/.env ${HOME_TIM}/docker-compose/.env

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
pushd ${HOME_TIM}/docker-compose
docker compose up -d

# Wait for 2 minutes before rebooting the system
sleep 120
sudo poweroff --reboot