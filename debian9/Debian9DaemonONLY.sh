#!/bin/bash

echo "Debian 9 "

echo "PTERO  0.7.18"

echo "DAEMON + PANEL"




echo "STEP 1" 

echo "PREPARATION"
sleep 3
sleep 3
bddpass=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w12 | head -n1)
userpass=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w12 | head -n1)
rm -rf sql.txt
rm -rf /var/www/*
echo "Identifiant SQL" >> sql.txt
echo "Utiliisateur : administrateur"  >> sql.txt
echo "Mot de passe :" >> sql.txt
echo ${bddpass} >> sql.txt
echo "Identifiant pterodactyl"  >> sql.txt
echo "Utilisateur : administrateur"  >> sql.txt
echo "Password"  >> sql.txt
echo ${userpass}  >> sql.txt
rm -rf /etc/systemd/system/pteroq.service
rm -rf /etc/systemd/system/wings.service

echo "nameserver 8.8.8.8" >> /etc/resolv.conf
echo "nameserver 8.8.4.4" >> /etc/resolv.conf
rm -rf /etc/apt/sources.list
echo "deb http://ftp2.fr.debian.org/debian/ stretch main contrib non-free" >> /etc/apt/sources.list
echo "deb http://ftp2.fr.debian.org/debian/ stretch-updates main contrib non-free" >> /etc/apt/sources.list
echo "deb http://security.debian.org/ stretch/updates main contrib non-free" >> /etc/apt/sources.list


read -p 'Entrez votre nom de domaine (ou l ip du vps si vous n en avez pas) ' domaine
echo "Votre nom de domaine a été mis sur : $domaine !"

sleep 1

read -p 'Utilisez vous un nom de domaine (exemple : montrucbidule.fr. ATTENTION 5.55.55.55 N EST PAS UN NOM DE DOMAINE)?  (y/n) ' -n 1 dom
sleep 1 
echo "Vous avez choisis $dom"
sleep 1 


sleep 2 
echo "======"
echo "======"
echo "======"
echo "======"
echo "STEP 2"

echo "REQUIREMENT"


sleep 3 


apt update && apt -y upgrade

apt install -y software-properties-common dirmngr ca-certificates apt-transport-https apt-transport-https ca-certificates curl gnupg2 software-properties-common zip unzip tar make gcc g++ python python-dev curl gnupg sudo nano 
wget -q https://packages.sury.org/php/apt.gpg -O- | apt-key add -
echo "deb https://packages.sury.org/php/ stretch main" | tee /etc/apt/sources.list.d/php.list
curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
curl -sL https://deb.nodesource.com/setup_12.x | bash -
apt update



apt install -y docker-ce nodejs mariadb-common mariadb-server mariadb-client php7.2 php7.2-cli php7.2-gd php7.2-mysql php7.2-pdo php7.2-mbstring php7.2-tokenizer php7.2-bcmath php7.2-xml php7.2-fpm php7.2-curl php7.2-zip mariadb-server apache2 libapache2-mod-php7.2 redis-server certbot curl



curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

systemctl start redis-server
systemctl enable redis-server
systemctl start mariadb
systemctl enable mariadb
systemctl enable docker
systemctl start docker


echo "Requirement Installed"
sleep 2
echo "====="

echo "====="

slepe 2
echo "====="
echo "Step 3 daemon"
echo "====="
sleep 2

mkdir -p /srv/daemon /srv/daemon-data
cd /srv/daemon
curl -L https://github.com/pterodactyl/daemon/releases/download/v0.6.13/daemon.tar.gz | tar --strip-components=1 -xzv

npm install --only=production --no-audit --unsafe-perm

echo "[Unit]" >> /etc/systemd/system/wings.service
echo "Description=Pterodactyl Wings Daemon" >> /etc/systemd/system/wings.service
echo "After=docker.service" >> /etc/systemd/system/wings.service
echo "" >> /etc/systemd/system/wings.service
echo "[Service]" >> /etc/systemd/system/wings.service
echo "User=root" >> /etc/systemd/system/wings.service
echo "#Group=some_group" >> /etc/systemd/system/wings.service
echo "WorkingDirectory=/srv/daemon" >> /etc/systemd/system/wings.service
echo "LimitNOFILE=4096" >> /etc/systemd/system/wings.service
echo "PIDFile=/var/run/wings/daemon.pid" >> /etc/systemd/system/wings.service
echo "ExecStart=/usr/bin/node /srv/daemon/src/index.js" >> /etc/systemd/system/wings.service
echo "Restart=on-failure" >> /etc/systemd/system/wings.service
echo "StartLimitInterval=600" >> /etc/systemd/system/wings.service
echo "" >> /etc/systemd/system/wings.service
echo "[Install]" >> /etc/systemd/system/wings.service
echo "WantedBy=multi-user.target" >> /etc/systemd/system/wings.service

read -p "Coller ici votre commande Token crée depuis le panel (commande pour le daemon)" cmd
${cmd} 
systemctl enable --now wings

echo "Fin du script"

echo "Vos identiifiiant phpmyadmin sont dans le fichier sql.txt"

sleep 5
