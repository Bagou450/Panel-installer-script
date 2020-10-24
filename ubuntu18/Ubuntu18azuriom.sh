#!/bin/bash
echo "=============================="
echo "Ubuntu 18.04"

echo "Azuriom"



echo "=============================="
echo "=============================="


echo "STEP 1" 

echo "PREPARATION"
echo "=============================="
echo "=============================="
sleep 3
sleep 3
bddpass=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w12 | head -n1)

rm -rf /root/id_azuriom.txt
rm -rf /var/www/azuriom/*
echo "Identifiant SQL" >> /root/id_azuriom.txt
echo "Utiliisateur : azuriom"  >> /root/id_azuriom.txt
echo "Base de données : azuriom" >> /root/id_azuriom.txt  
echo "Mot de passe :" >> /root/id_azuriom.txt
echo ${bddpass} >> /root/id_azuriom.txt


echo "nameserver 8.8.8.8" >> /etc/resolv.conf
echo "nameserver 8.8.4.4" >> /etc/resolv.conf
rm -rf /etc/apt/sources.list
echo "deb http://fr.archive.ubuntu.com/ubuntu/ bionic main universe " >> /etc/apt/sources.list
echo "deb-src http://fr.archive.ubuntu.com/ubuntu/ bionic main universe " >> /etc/apt/sources.list
echo "" >> /etc/apt/sources.list
echo "deb http://fr.archive.ubuntu.com/ubuntu/ bionic-security main universe " >> /etc/apt/sources.list
echo "deb http://fr.archive.ubuntu.com/ubuntu/ bionic-updates main universe " >> /etc/apt/sources.list
echo "" >> /etc/apt/sources.list
echo "deb-src http://fr.archive.ubuntu.com/ubuntu/ bionic-security main universe " >> /etc/apt/sources.list
echo "deb-src http://fr.archive.ubuntu.com/ubuntu/ bionic-updates main universe " >> /etc/apt/sources.list


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
LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php
apt update



apt install -y nodejs mariadb-common mariadb-server mariadb-client php7.3 php7.3-fpm php7.3-mysql php7.3-pgsql php7.3-sqlite php7.3-bcmath php7.3-mbstring php7.3-xml php7.3-curl php7.3-zip php7.3-gd mariadb-server apache2 libapache2-mod-php7.3 certbot curl unzip zip




echo "=============================="
echo "Requirement Installed"
sleep 2

echo "=============================="
echo "=============================="
echo "=============================="
echo "=============================="
echo "STEP 3"

echo "PANEL"
sleep 3 
echo "=============================="
echo "=============================="
mkdir /var/www/azuriom
cd /var/www/azuriom
wget https://azuriom.com/storage/AzuriomInstaller.zip
unzip AzuriomInstaller.zip
rm -rf AzuriomInstaller.zip
chmod -R 755 /var/www/azuriom && chown -R www-data:www-data /var/www/azuriom
mysql -u root -e "DROP USER azuriom;"
mysql -u root -e "DROP DATABASE azuriom;"
mysql -u root -e "CREATE USER azuriom IDENTIFIED BY '"${bddpass}"';"
mysql -u root -e "CREATE DATABASE azuriom;"
mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO azuriom WITH GRANT OPTION;"




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
		rm -rf /etc/apache2/sites-enabled/azuriom.conf

echo "<VirtualHost *:80>" >> /etc/apache2/sites-enabled/azuriom.conf
echo "  ServerName" $domaine >> /etc/apache2/sites-enabled/azuriom.conf
echo "  RewriteEngine On" >> /etc/apache2/sites-enabled/azuriom.conf
echo "  RewriteCond %{HTTPS} !=on" >> /etc/apache2/sites-enabled/azuriom.conf
echo "  RewriteRule ^/?(.*) https://%{SERVER_NAME}/$1 [R,L] " >> /etc/apache2/sites-enabled/azuriom.conf
echo "</VirtualHost>" >> /etc/apache2/sites-enabled/azuriom.conf
echo "<VirtualHost *:443>" >> /etc/apache2/sites-enabled/azuriom.conf
echo "  ServerName" $domaine >> /etc/apache2/sites-enabled/azuriom.conf
echo "  DocumentRoot "/var/www/azuriom"" >> /etc/apache2/sites-enabled/azuriom.conf
echo "  AllowEncodedSlashes On" >> /etc/apache2/sites-enabled/azuriom.conf
echo "  php_value upload_max_filesize 100M" >> /etc/apache2/sites-enabled/azuriom.conf
echo "  php_value post_max_size 100M" >> /etc/apache2/sites-enabled/azuriom.conf
echo "  <Directory "/var/www/azuriom">" >> /etc/apache2/sites-enabled/azuriom.conf
echo "    AllowOverride all" >> /etc/apache2/sites-enabled/azuriom.conf
echo "  </Directory>" >> /etc/apache2/sites-enabled/azuriom.conf
echo "  SSLEngine on" >> /etc/apache2/sites-enabled/azuriom.conf
echo "  SSLCertificateFile /etc/letsencrypt/live/"$domaine"/fullchain.pem" >> /etc/apache2/sites-enabled/azuriom.conf
echo "  SSLCertificateKeyFile /etc/letsencrypt/live/"$domaine"/privkey.pem" >> /etc/apache2/sites-enabled/azuriom.conf
echo "</VirtualHost> " >> /etc/apache2/sites-enabled/azuriom.conf

chmod -R 755 /var/www/azuriom && chown -R www-data:www-data /var/www/azuriom
a2enmod rewrite
a2enmod ssl
service apache2 restart

else
		echo "=============================="

        echo "Vous n'avez pas de nom de domaine certbot ne vas pas s installer"
		echo "=============================="

		sleep 5
				rm -rf /etc/apache2/sites-enabled/azuriom.conf

echo "<VirtualHost *:80>" >> /etc/apache2/sites-enabled/azuriom.conf
echo "  ServerName" $domaine >> /etc/apache2/sites-enabled/azuriom.conf
echo "  DocumentRoot "/var/www/azuriom"" >> /etc/apache2/sites-enabled/azuriom.conf
echo "  AllowEncodedSlashes On" >> /etc/apache2/sites-enabled/azuriom.conf
echo "  php_value upload_max_filesize 100M" >> /etc/apache2/sites-enabled/azuriom.conf
echo "  php_value post_max_size 100M" >> /etc/apache2/sites-enabled/azuriom.conf
echo "  <Directory "/var/www/azuriom">" >> /etc/apache2/sites-enabled/azuriom.conf
echo "    AllowOverride all" >> /etc/apache2/sites-enabled/azuriom.conf
echo "  </Directory>" >> /etc/apache2/sites-enabled/azuriom.conf
echo "</VirtualHost>" >> /etc/apache2/sites-enabled/azuriom.conf
a2enmod rewrite
a2enmod ssl
service apache2 restart

fi


sleep 3

sleep 1
cd /var/www/azuriom
mkdir pma
cd pma
wget https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-all-languages.zip
unzip phpMyAdmin-5.0.2-all-languages.zip
mv phpMyAdmin-5.0.2-all-languages/* /var/www/azuriom/pma
rm -rf phpM*


echo "=============================="

echo "=============================="
echo "Fin du script"
echo ""
echo "Vos identiifiiant sont dans le fichier /root/id_azuriom.txt"
if [ $dom = "y" ]
then
echo "Pour la premiere utilisation veuillez accedez a azuriom ici https://$domaine/install.php"
else
echo "Pour la premiere utilisation veuillez accedez a azuriom ici http://$domaine/install.php"
fi
echo "=============================="
echo "=============================="
sleep 5
