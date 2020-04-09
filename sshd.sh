#!/bin/bash
##################################################
# SSH-server install script                      #
# Author by Dethroner, 2020                      #
##################################################

#################################################################################
echo "Start..."

### Vars
username=dethroner
ssh_key="ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAi7In5b1Lt5B6ea+ExDNrGksDZ84SsetdfkBZx5dbFgxMMBjnAOZw7XO4PFb0AJgpa/Dgocqrzd5fWBOl74XJXXz5xX4r7U1OoHEhxkU2kC7dkkBA3Bj8iSPTw8ikCPun8KaHRWId3r0W4NY/Z2Pk4uimKKGOS26nfsbZeGkr931Z2Vq4TjkdIsjPDDz0S/MF4tnBJpq8/Y2qG1GGtTnSk/z0va9qi9mRJn085whyDmOPEMy8tfeZA2soDPGPH+OimzJJM6jtYM4+VCm5crSqrN3Rv3veyBb3yFIKa2umwzex+2H9WebTLTlrD4tAUUYDi9bIwLQLaoWoIEudJbUL+Q== dethroner@tut.by"

### Upgrade distributive
echo "Start upgrade distributive..."
apt update
apt -y dist-upgrade && apt -y upgrade

### Install
echo "Install SSH-server & sudo"
apt -y install openssh-server sudo

### Add User
echo "Add User"
groupadd $username
useradd -g $username -m -d /home/$username -c "$username user" -s /bin/bash $username

### Add SSH key
echo "Add SSH key"
mkdir /home/$username/.ssh
echo $ssh_key > /home/$username/.ssh/authorized_keys
chmod 640 /home/$username/.ssh/*
chown -R $username:$username /home/$username/.ssh

### Add User in sudo
echo "Add User in sudo"
echo "$username  ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

### Edit SSH-server configuration
echo "Edit SSH-server configuration"
sed -i '
/#ListenAddress ::/c Protocol 2
/#SyslogFacility/c SyslogFacility AUTH
/#StrictModes/c StrictModes yes
/#PermitRootLogin/c PermitRootLogin no
/#PubkeyAuthentication/c PubkeyAuthentication yes
/#AuthorizedKeysFile/c AuthorizedKeysFile %h/.ssh/authorized_keys
/#PasswordAuthentication/c PasswordAuthentication no
/#PermitEmptyPasswords/c PermitEmptyPasswords no
' /etc/ssh/sshd_config

### Restart SSH-server
echo "Restart SSH-server"
/etc/init.d/ssh restart

### Autoclean
apt -y autoremove && apt -y autoclean
#################################################################################