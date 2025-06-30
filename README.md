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
# Run the custom script after dietpi has finished setting up
AUTO_SETUP_CUSTOM_SCRIPT_EXEC=0
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

Log in as `tim` and set a password by running:
```bash
sudo passwd tim
```

Change the passwords and ip settings within the `docker-compose/.env` file and restart docker compose by running:
```bash
cd ${HOME}/docker-compose && docker compose restart
```

Check that everything is running as it should be by running the alias command `dps`.