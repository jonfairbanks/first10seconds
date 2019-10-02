#!/bin/bash

# Check if user is root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Upgrade installed packages to latest
echo -e "\nRunning a package upgrade...\n"
apt-get -qq update && apt-get -qq dist-upgrade && apt-get -qq upgrade -y && apt-get -qq autoremove -y

# Install common packages
echo -e "\nInstalling common packages...\n"
echo -e "\nPython, git, nmap, fail2ban, unattended-upgrades, curl, ufw, docker, nvm, kubeadm\n"
apt-get -qq install fail2ban git git-core nmap mitmproxy python-dev python-numpy python-scipy python-setuptools unattended-upgrades curl ufw kubeadm -y

curl -L https://get.docker.com | sh
sudo usermod -aG docker $USER

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# Create aliases
RASPI=/proc/device-tree/model
if test -f "$RASPI"; then
    # This section will only run if the device is a Raspberry Pi
    echo -e "\nCreating alias 'temp' for viewing Pi temperatures...\n"
    cd ~ && echo "alias temp='sudo /opt/vc/bin/vcgencmd measure_temp'" >> .bash_aliases
fi

# Create default directories
echo -e "Creating default home folders: logs/ scripts/"
cd ~ && mkdir -p logs scripts

# Install and configure firewall
echo -e "\nConfiguring ufw firewall...\n"
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow 80
ufw allow 443

sed -i.bak 's/ENABLED=no/ENABLED=yes/g' /etc/ufw/ufw.conf
chmod 0644 /etc/ufw/ufw.conf

# Setup unattended-upgrades
echo -e "\nConfiguring unattended-upgrades...\n"
touch /etc/apt/apt.conf.d/10periodic
echo 'APT::Periodic::Update-Package-Lists "1";' >> /etc/apt/apt.conf.d/10periodic
echo 'APT::Periodic::Download-Upgradeable-Packages "1";' >> /etc/apt/apt.conf.d/10periodic
echo 'APT::Periodic::AutocleanInterval "7";' >> /etc/apt/apt.conf.d/10periodic
echo 'APT::Periodic::Unattended-Upgrade "1";' >> /etc/apt/apt.conf.d/10periodic

# Set timezone to PST
echo -e "\nUpdating Timezone to PST...\n"
timedatectl set-timezone PST

# Done
echo -e "\nSetup complete!"

read -n1 -r -p "Press space to continue..." key

if [ "$key" = '' ]; then
    exit
fi