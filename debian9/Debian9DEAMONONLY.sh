#!/bin/bash
echo "=============================="
echo "=============================="
echo "Debian 9 "

echo "PTERO  0.7.18"

echo "DAEMON + PANEL"
echo "=============================="

echo "=============================="

echo "STEP 1" 

echo "PREPARATION"
echo "=============================="
echo "=============================="
sleep 3
sleep 3
bddpass=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w12 | head -n1)
userpass=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w12 | head -n1)
rm -rf /root/id_ptero.txt
rm -rf /var/www/pterodactyl/*
echo "Identifiant SQL" >> /root/id_ptero.txt
echo "Utiliisateur : administrateur"  >> /root/id_ptero.txt
echo "Mot de passe :" >> /root/id_ptero.txt
echo ${bddpass} >> /root/id_ptero.txt
echo "Identifiant pterodactyl"  >> /root/id_ptero.txt
echo "Utilisateur : administrateur"  >> /root/id_ptero.txt
echo "Password"  >> /root/id_ptero.txt
echo ${userpass}  >> /root/id_ptero.txt
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
echo "=============================="
echo "=============================="
echo "STEP 2"

echo "REQUIREMENT"
echo "=============================="
echo "=============================="

sleep 3 


apt update && apt -y upgrade

apt install -y zip unzip tar make gcc g++ python python-dev curl gnupg apt-transport-https ca-certificates curl gnupg2 software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
curl -sL https://deb.nodesource.com/setup_12.x | bash -
apt update



apt install -y docker-ce nodejs certbot curl




systemctl start redis-server
systemctl enable redis-server
systemctl start mariadb
systemctl enable mariadb
systemctl enable docker
systemctl start docker

if [ $dom = "y" ]
then


		echo "=============================="
        echo "Vous avez un nom de domaine instalation de certbot pour le httpS"
		echo "=============================="

		sleep 2
		apt update
		apt install -y certbot
		echo "Certbot installer création du certificat"
		service apache2 stop
		service nginx stop 
		certbot certonly --standalone --agree-tos --no-eff-email --register-unsafely-without-email -d $domaine
		echo "=============================="

		echo "Certificat ssl crée"
		echo "=============================="
else
		echo "=============================="

        echo "Vous n'avez pas de nom de domaine certbot ne vas pas s installer"
		echo "=============================="

		sleep 5
fi
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

echo "Identifiant pterodactyl"
echo "Utilisateur : administrateur"  
echo "Password"  
echo ${userpass}  
read -p "Coller ici votre commande Token crée depuis le panel (commande pour le daemon)" cmd
${cmd} 
systemctl enable --now wings
echo "=============================="
echo "=============================="
echo "Fin du script"

echo "Vos identiifiiant sont dans le fichier /root/id_ptero.txt"
if [ $dom = "y" ]
then
echo "Veuillez accedez a Pterodactyl ici https://$domaine/"
echo "Veuillez accedez a PhpMyAdmin ici https://$domaine/pma"
else
echo "Veuillez accedez a Pterodactyl ici http://$domaine/"
echo "Veuillez accedez a PhpMyAdmin ici http://$domaine/pma"
fi
echo "=============================="
echo "=============================="

sleep 5
