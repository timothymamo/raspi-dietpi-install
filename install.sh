#!/bin/bash

# Change directory to $[HOME]
pushd ${HOME}

sudo ssh-keygen -a 100 -t ed25519 -f ~/.ssh/id_ed25519 -C "${USER}@${HOST}"
echo "host github.com
 HostName github.com
 IdentityFile ~/.ssh/id_ed25519" > ${HOME}/.ssh/config

echo "[init]
	defaultBranch = main
[user]
	name = Tim Mamo
	email = tim@ndietpi${HOST}.home
[color]
	ui = true
[color "branch"]
	current = yellow reverse
	local = yellow
	remote = green
[color "diff"]
	meta = yellow bold
	frag = magenta bold
	old = red bold
	new = green bold
[color "status"]
	added = yellow
	changed = green
	untracked = red
[gui]
	editor = vim" > ${HOME}/.gitconfig

# Set docker autocompletion
mkdir -p ${HOME}/.docker/completions
docker completion zsh > ${HOME}/.docker/completions/_docker

# Install Homebrew
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Set brew in shell
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Install everything within the Brewfile
brew bundle
brew install --cask font-fira-code-nerd-font

export PATH=/home/linuxbrew/.linuxbrew/bin:$PATH

# Set zsh as the default shell for the ${USER}
echo "Settign zsh as default shell for ${USER}"
command -v zsh | sudo tee -a /etc/shells
chsh -s "$(command -v zsh)" ${USER}

# Start the containers
pushd ${HOME}/docker-compose
docker compose up -d

# Crate a password for the user
sudo passwd ${USER}

# Reboot the system
sudo poweroff --reboot