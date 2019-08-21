# first10seconds

Automating the first 10 minutes on a Linux server

Ideally you would use Chef/Puppet, but short of that, you can use this script to:
- Run Updates, Upgrades and Clean Up
- Install Common Packages
    - Python, git, nmap, fail2ban, unattended-upgrades, curl, ufw, docker, nvm, kubeadm
- Create default aliases and directories
- Configure the Firewall
- Setup unattended-upgrades
- Set the Timezone to PST

`curl -sSL https://raw.githubusercontent.com/jonfairbanks/first10seconds/master/first10seconds.sh | sh`