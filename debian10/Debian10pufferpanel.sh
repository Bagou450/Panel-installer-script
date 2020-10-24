#!/bin/bash
echo "=============================="
echo "=============================="
echo "Debian 10"

echo "Pufferpanel  v2"

echo "PANEL"

read -p 'Entrez votre nom de domaine (ou l ip du vps si vous n en avez pas) ' domaine
echo "Votre nom de domaine a été mis sur : $domaine !"

bddpass=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w12 | head -n1)

echo "=============================="
echo "=============================="

echo "STEP 1" 

echo "PREPARATION"
echo "=============================="
echo "=============================="
sleep 3
sleep 3
apt remove --purge pufferpanel

echo "nameserver 8.8.8.8" >> /etc/resolv.conf
echo "nameserver 8.8.4.4" >> /etc/resolv.conf
rm -rf /etc/apt/sources.list
echo "deb http://ftp.fr.debian.org/debian/ stable main contrib non-free" >> /etc/apt/sources.list
echo "deb-src http://ftp.fr.debian.org/debian/ stable main contrib non-free" >> /etc/apt/sources.list
echo "" >> /etc/apt/sources.list
echo "deb http://ftp.fr.debian.org/debian/ stable-updates main contrib non-free" >> /etc/apt/sources.list
echo "deb-src http://ftp.fr.debian.org/debian/ stable-updates main contrib non-free" >> /etc/apt/sources.list
echo "" >> /etc/apt/sources.list
echo "deb http://security.debian.org/ stable/updates main" >> /etc/apt/sources.list
echo "deb-src http://security.debian.org/ stable/updates main" >> /etc/apt/sources.list
echo "" >> /etc/apt/sources.list
echo "deb http://ftp.debian.org/debian buster-backports main" >> /etc/apt/sources.list
echo "deb-src http://ftp.debian.org/debian buster-backports main" >> /etc/apt/sources.list


rm -rf /root/id_pufferpanel.txt
echo "Identifiant Pufferpanel" >> /root/id_pufferpanel.txt
echo "Utiliisateur : mail@exemple.com "  >> /root/id_pufferpanel.txt
echo "Mot de passe :" >> /root/id_pufferpanel.txt
echo ${bddpass} >> /root/id_pufferpanel.txt
sleep 2
echo "=============================="
echo "=============================="
echo "STEP 2"

echo "PANEL"
sleep 3 
echo "=============================="
echo "=============================="
apt update 
apt install curl sudo apt-transport-https
curl -s https://packagecloud.io/install/repositories/pufferpanel/pufferpanel/script.deb.sh | sudo bash
apt update
apt-get -y install pufferpanel
systemctl enable pufferpanel
pufferpanel user add --admin --email mail@exemple.com --name exemple --password ${bddpass}
pufferpanel template import
systemctl start pufferpanel
sleep 3

echo "=============================="
echo "=============================="

echo "Fin du script"
echo "Vos identifiant sont dans /root/id_pufferpanel.txt"
echo "Votre pufferpanel est ici http://$domaine:8080"
echo "=============================="
echo "=============================="
sleep 5
