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

apt install -y software-properties-common dirmngr ca-certificates apt-transport-https apt-transport-https ca-certificates curl gnupg2 software-properties-common zip unzip tar make gcc g++ python python-dev curl gnupg sudo 
wget -q https://packages.sury.org/php/apt.gpg -O- | apt-key add -
echo "deb https://packages.sury.org/php/ stretch main" | tee /etc/apt/sources.list.d/php.list
curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
curl -sL https://deb.nodesource.com/setup_12.x | bash -
apt update



apt install -y docker-ce nodejs mariadb-common mariadb-server mariadb-client php7.3 php7.3-cli php7.3-gd php7.3-mysql php7.3-pdo php7.3-mbstring php7.3-tokenizer php7.3-bcmath php7.3-xml php7.3-fpm php7.3-curl php7.3-zip mariadb-server apache2 libapache2-mod-php7.3 redis-server certbot curl




systemctl start redis-server
systemctl enable redis-server
systemctl start mariadb
systemctl enable mariadb
systemctl enable docker
systemctl start docker

echo "=============================="
echo "Requirement Installed"
sleep 2

echo "=============================="
echo "=============================="

echo "STEP 3"

echo "PANEL"
echo "=============================="
echo "=============================="
sleep 3 




mysql -u root -e "DROP USER administrateur;"
mysql -u root -e "DROP DATABASE ptero;"
mysql -u root -e "CREATE USER administrateur IDENTIFIED BY '"${bddpass}"';"
mysql -u root -e "CREATE DATABASE ptero;"
mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO administrateur WITH GRANT OPTION;"
mkdir -p /var/www/pterodactyl
cd /var/www/pterodactyl
curl -Lo panel.tar.gz https://github.com/pterodactyl/panel/releases/download/v0.7.18/panel.tar.gz
tar --strip-components=1 -xzvf panel.tar.gz
chmod -R 755 storage/* bootstrap/cache/
cp .env.example .env
php -r "copy('https://raw.githubusercontent.com/Bagou450/Panel-installer-script/main/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === '756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php --version=1.10.16

php composer.phar install --no-dev --optimize-autoloader
echo "50%"
sleep 3
php artisan key:generate --force
if [ $dom = "y" ]
then

php artisan p:environment:setup --author bagou@zelkoa.fr --url https://$domaine --timezone Europe/Paris --cache file --session database --queue database
else
php artisan p:environment:setup --author bagou@zelkoa.fr --url http://$domaine --timezone Europe/Paris --cache file --session database --queue database 
fi
echo "script en pause pendant 5s"
echo "Voicie ce que vous devez entrer"
echo "Utiilisateur : administrateur"
echo "Mot de passe :"
echo ${bddpass}
echo "BDD : ptero"


sleep 5
php artisan p:environment:database --host 127.0.0.1 --port 3306 --database ptero --username administrateur --password ${bddpass}

php artisan migrate --seed --force

echo "création de l'utilisateur pterodactyl."
sleep 4
php artisan p:user:make --admin 1 --email mail@exemple.com --username administrateur --name-first exemple --name-last name --password ${userpass}
chown -R www-data:www-data * 

echo "# Pterodactyl Queue Worker File" >> /etc/systemd/system/pteroq.service
echo "# ----------------------------------" >> /etc/systemd/system/pteroq.service
echo "" >> /etc/systemd/system/pteroq.service
echo "[Unit]" >> /etc/systemd/system/pteroq.service
echo "Description=Pterodactyl Queue Worker" >> /etc/systemd/system/pteroq.service
echo "After=redis-server.service" >> /etc/systemd/system/pteroq.service
echo "" >> /etc/systemd/system/pteroq.service
echo "[Service]" >> /etc/systemd/system/pteroq.service
echo "# On some systems the user and group might be different." >> /etc/systemd/system/pteroq.service
echo "User=www-data" >> /etc/systemd/system/pteroq.service
echo "Group=www-data" >> /etc/systemd/system/pteroq.service
echo "Restart=always" >> /etc/systemd/system/pteroq.service
echo "ExecStart=/usr/bin/php /var/www/pterodactyl/artisan queue:work --queue=high,standard,low --sleep=3 --tries=3" >> /etc/systemd/system/pteroq.service
echo "" >> /etc/systemd/system/pteroq.service
echo "[Install]" >> /etc/systemd/system/pteroq.service
echo "WantedBy=multi-user.target" >> /etc/systemd/system/pteroq.service

sudo systemctl enable --now redis-server
sudo systemctl enable --now pteroq.service


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
		rm -rf /etc/apache2/sites-enabled/pterodactyl.conf

echo "<VirtualHost *:80>" >> /etc/apache2/sites-enabled/pterodactyl.conf
echo "  ServerName" $domaine >> /etc/apache2/sites-enabled/pterodactyl.conf
echo "  RewriteEngine On" >> /etc/apache2/sites-enabled/pterodactyl.conf
echo "  RewriteCond %{HTTPS} !=on" >> /etc/apache2/sites-enabled/pterodactyl.conf
echo "  RewriteRule ^/?(.*) https://%{SERVER_NAME}/$1 [R,L] " >> /etc/apache2/sites-enabled/pterodactyl.conf
echo "</VirtualHost>" >> /etc/apache2/sites-enabled/pterodactyl.conf
echo "<VirtualHost *:443>" >> /etc/apache2/sites-enabled/pterodactyl.conf
echo "  ServerName" $domaine >> /etc/apache2/sites-enabled/pterodactyl.conf
echo "  DocumentRoot "/var/www/pterodactyl/public"" >> /etc/apache2/sites-enabled/pterodactyl.conf
echo "  AllowEncodedSlashes On" >> /etc/apache2/sites-enabled/pterodactyl.conf
echo "  php_value upload_max_filesize 100M" >> /etc/apache2/sites-enabled/pterodactyl.conf
echo "  php_value post_max_size 100M" >> /etc/apache2/sites-enabled/pterodactyl.conf
echo "  <Directory "/var/www/pterodactyl/public">" >> /etc/apache2/sites-enabled/pterodactyl.conf
echo "    AllowOverride all" >> /etc/apache2/sites-enabled/pterodactyl.conf
echo "  </Directory>" >> /etc/apache2/sites-enabled/pterodactyl.conf
echo "  SSLEngine on" >> /etc/apache2/sites-enabled/pterodactyl.conf
echo "  SSLCertificateFile /etc/letsencrypt/live/"$domaine"/fullchain.pem" >> /etc/apache2/sites-enabled/pterodactyl.conf
echo "  SSLCertificateKeyFile /etc/letsencrypt/live/"$domaine"/privkey.pem" >> /etc/apache2/sites-enabled/pterodactyl.conf
echo "</VirtualHost> " >> /etc/apache2/sites-enabled/pterodactyl.conf

chmod -R 755 /var/www/pterodactyl/public && chown -R www-data:www-data /var/www/pterodactyl/public
a2enmod rewrite
a2enmod ssl
service apache2 restart

else
		echo "=============================="

        echo "Vous n'avez pas de nom de domaine certbot ne vas pas s installer"
		echo "=============================="

		sleep 5
				rm -rf /etc/apache2/sites-enabled/pterodactyl.conf

echo "<VirtualHost *:80>" >> /etc/apache2/sites-enabled/pterodactyl.conf
echo "  ServerName" $domaine >> /etc/apache2/sites-enabled/pterodactyl.conf
echo "  DocumentRoot "/var/www/pterodactyl/public"" >> /etc/apache2/sites-enabled/pterodactyl.conf
echo "  AllowEncodedSlashes On" >> /etc/apache2/sites-enabled/pterodactyl.conf
echo "  php_value upload_max_filesize 100M" >> /etc/apache2/sites-enabled/pterodactyl.conf
echo "  php_value post_max_size 100M" >> /etc/apache2/sites-enabled/pterodactyl.conf
echo "  <Directory "/var/www/pterodactyl/public">" >> /etc/apache2/sites-enabled/pterodactyl.conf
echo "    AllowOverride all" >> /etc/apache2/sites-enabled/pterodactyl.conf
echo "  </Directory>" >> /etc/apache2/sites-enabled/pterodactyl.conf
echo "</VirtualHost>" >> /etc/apache2/sites-enabled/pterodactyl.conf
a2enmod rewrite
a2enmod ssl
service apache2 restart

fi


sleep 3

sleep 1
cd /var/www/pterodactyl/public/
mkdir pma
cd pma
wget https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-all-languages.zip
unzip phpMyAdmin-5.0.2-all-languages.zip
mv phpMyAdmin-5.0.2-all-languages/* /var/www/pterodactyl/public/pma
rm -rf phpM*


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
