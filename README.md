# DietPi Install

Install DietPI as described [here](https://dietpi.com/docs/install/).

Once you have flashed the DietPi image onto the microSD card change the following values within the following files:

`dietpi.txt`
```bash
AUTO_SETUP_GLOBAL_PASSWORD=<password>
AUTO_SETUP_TIMEZONE=Europe/Amsterdam
# Enable Wifi
AUTO_SETUP_NET_WIFI_ENABLED=1
# Change the hostname
AUTO_SETUP_NET_HOSTNAME=DietPi<Name>
# Disable HDMI/video output
AUTO_SETUP_HEADLESS=1
# Add url to custom script - runs after dietpi has finished setting up
AUTO_SETUP_CUSTOM_SCRIPT_EXEC=<url-to-script>
# Set OpenSSH as the SSH server
AUTO_SETUP_SSH_SERVER_INDEX=-2
# Set the public key for the root and dietpi users
AUTO_SETUP_SSH_PUBKEY=<ssh-ed25519-key-pub>
#  Non-interactive first run setup
AUTO_SETUP_AUTOMATED=1
# Install git, docker and docker-compose
AUTO_SETUP_INSTALL_SOFTWARE_ID=17 162 134
# Disable ssh password login
SOFTWARE_DISABLE_SSH_PASSWORD_LOGINS=1
```

`dietpi-wifi.txt`
```bash
aWIFI_SSID[0]='<SSID>'
aWIFI_KEY[0]='<SSID_password>'
```

Place the microSD card in the RaspberryPi and plug it in. Wait for the system to install itself (the front LED will stop flashing when its done).

# Setup DietPi

Log in as `tim` and modify the `docker-compose/.env` file.

```bash
nano ${HOME}/docker-compose/.env
```

Run the `install.sh` script:
```bash
./install.sh
```

The script will ask you to set a new password for the user as well as asking you to enter the password whenever a sudo command is required.
Once the script finishes the system will reboot.

Re-login, now you should be running `zsh` with `starship` for your prompt, and check that everything is running as it should be by running the alias command `dps`.