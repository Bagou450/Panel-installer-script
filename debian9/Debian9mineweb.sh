#!/bin/bash
echo "=============================="
echo "Debian 9 "

echo "MineWeb"

echo "=============================="
echo "=============================="


echo "STEP 1" 

echo "PREPARATION"
echo "=============================="
echo "=============================="
sleep 3
sleep 3
bddpass=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w12 | head -n1)

rm -rf /root/id_mineweb.txt
rm -rf /var/www/mineweb/*
echo "Identifiant SQL" >> /root/id_mineweb.txt
echo "Utiliisateur : mineweb"  >> /root/id_mineweb.txt
echo "Base de données : mineweb" >> /root/id_mineweb.txt  
echo "Mot de passe :" >> /root/id_mineweb.txt
echo ${bddpass} >> /root/id_mineweb.txt


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
mkdir /var/www/mineweb
cd /var/www/mineweb
wget https://github.com/MineWeb/MineWebCMS/archive/master.zip
unzip master.zip
mv MineWebCMS-master/* /var/www/mineweb
echo "<IfModule mod_rewrite.c>" >> /var/www/mineweb/.htaccess
echo "   RewriteEngine on" >> /var/www/mineweb/.htaccess
echo "   RewriteRule    ^$ app/webroot/    [L]" >> /var/www/mineweb/.htaccess
echo "   RewriteRule    (.*) app/webroot/$1 [L]" >> /var/www/mineweb/.htaccess
echo "</IfModule>" >> /var/www/mineweb/.htaccess
echo "#Cache" >> /var/www/mineweb/.htaccess
echo "<IfModule mod_expires.c>" >> /var/www/mineweb/.htaccess
echo "    ExpiresActive on" >> /var/www/mineweb/.htaccess
echo "  	ExpiresDefault "access plus 1 seconds"" >> /var/www/mineweb/.htaccess
echo "	ExpiresByType image/jpg 			"access plus 1 week"" >> /var/www/mineweb/.htaccess
echo "	ExpiresByType image/jpeg 			"access plus 1 week"" >> /var/www/mineweb/.htaccess
echo "	ExpiresByType image/png 			"access plus 1 week"" >> /var/www/mineweb/.htaccess
echo "	ExpiresByType image/gif 			"access plus 1 week"" >> /var/www/mineweb/.htaccess
echo "	ExpiresByType image/svg+xml			"access plus 1 week"" >> /var/www/mineweb/.htaccess
echo "	AddType image/x-icon .ico" >> /var/www/mineweb/.htaccess
echo "	ExpiresByType image/ico 			"access plus 1 week"" >> /var/www/mineweb/.htaccess
echo "	ExpiresByType image/icon 			"access plus 1 week"" >> /var/www/mineweb/.htaccess
echo "	ExpiresByType image/x-icon 			"access plus 1 week"" >> /var/www/mineweb/.htaccess
echo "  # CSS" >> /var/www/mineweb/.htaccess
echo "    ExpiresByType text/css                "access plus 1 month"" >> /var/www/mineweb/.htaccess
echo "  # JavaScript" >> /var/www/mineweb/.htaccess
echo "    ExpiresByType application/javascript  "access plus 1 month"" >> /var/www/mineweb/.htaccess
echo "</IfModule>" >> /var/www/mineweb/.htaccess

rm -rf master.zip
rm -rf MineWebCMS-master
https://raw.githubusercontent.com/MineWeb/MineWebCMS/development/.htaccess
chmod -R 755 /var/www/mineweb && chown -R www-data:www-data /var/www/mineweb
mysql -u root -e "DROP USER mineweb;"
mysql -u root -e "DROP DATABASE mineweb;"
mysql -u root -e "CREATE USER mineweb IDENTIFIED BY '"${bddpass}"';"
mysql -u root -e "CREATE DATABASE mineweb;"
mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO mineweb WITH GRANT OPTION;"




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

echo "<VirtualHost *:80>" >> /etc/apache2/sites-enabled/mineweb.conf
echo "  ServerName" $domaine >> /etc/apache2/sites-enabled/mineweb.conf
echo "  RewriteEngine On" >> /etc/apache2/sites-enabled/mineweb.conf
echo "  RewriteCond %{HTTPS} !=on" >> /etc/apache2/sites-enabled/mineweb.conf
echo "  RewriteRule ^/?(.*) https://%{SERVER_NAME}/$1 [R,L] " >> /etc/apache2/sites-enabled/mineweb.conf
echo "</VirtualHost>" >> /etc/apache2/sites-enabled/mineweb.conf
echo "<VirtualHost *:443>" >> /etc/apache2/sites-enabled/mineweb.conf
echo "  ServerName" $domaine >> /etc/apache2/sites-enabled/mineweb.conf
echo "  DocumentRoot "/var/www/mineweb"" >> /etc/apache2/sites-enabled/mineweb.conf
echo "  AllowEncodedSlashes On" >> /etc/apache2/sites-enabled/mineweb.conf
echo "  php_value upload_max_filesize 100M" >> /etc/apache2/sites-enabled/mineweb.conf
echo "  php_value post_max_size 100M" >> /etc/apache2/sites-enabled/mineweb.conf
echo "  <Directory "/var/www/mineweb">" >> /etc/apache2/sites-enabled/mineweb.conf
echo "    AllowOverride all" >> /etc/apache2/sites-enabled/mineweb.conf
echo "  </Directory>" >> /etc/apache2/sites-enabled/mineweb.conf
echo "  SSLEngine on" >> /etc/apache2/sites-enabled/mineweb.conf
echo "  SSLCertificateFile /etc/letsencrypt/live/"$domaine"/fullchain.pem" >> /etc/apache2/sites-enabled/mineweb.conf
echo "  SSLCertificateKeyFile /etc/letsencrypt/live/"$domaine"/privkey.pem" >> /etc/apache2/sites-enabled/mineweb.conf
echo "</VirtualHost> " >> /etc/apache2/sites-enabled/mineweb.conf

chmod -R 755 /var/www/mineweb && chown -R www-data:www-data /var/www/mineweb
a2enmod rewrite
a2enmod ssl
service apache2 restart

else
		echo "=============================="

        echo "Vous n'avez pas de nom de domaine certbot ne vas pas s installer"
		echo "=============================="

		sleep 5
				rm -rf /etc/apache2/sites-enabled/mineweb.conf

echo "<VirtualHost *:80>" >> /etc/apache2/sites-enabled/mineweb.conf
echo "  ServerName" $domaine >> /etc/apache2/sites-enabled/mineweb.conf
echo "  DocumentRoot "/var/www/mineweb"" >> /etc/apache2/sites-enabled/mineweb.conf
echo "  AllowEncodedSlashes On" >> /etc/apache2/sites-enabled/mineweb.conf
echo "  php_value upload_max_filesize 100M" >> /etc/apache2/sites-enabled/mineweb.conf
echo "  php_value post_max_size 100M" >> /etc/apache2/sites-enabled/mineweb.conf
echo "  <Directory "/var/www/mineweb">" >> /etc/apache2/sites-enabled/mineweb.conf
echo "    AllowOverride all" >> /etc/apache2/sites-enabled/mineweb.conf
echo "  </Directory>" >> /etc/apache2/sites-enabled/mineweb.conf
echo "</VirtualHost>" >> /etc/apache2/sites-enabled/mineweb.conf
a2enmod rewrite
a2enmod ssl
service apache2 restart

fi


sleep 3

sleep 1
cd /var/www/mineweb
mkdir pma
cd pma
wget https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-all-languages.zip
unzip phpMyAdmin-5.0.2-all-languages.zip
mv phpMyAdmin-5.0.2-all-languages/* /var/www/mineweb/pma
rm -rf phpM*


echo "=============================="

echo "=============================="
echo "Fin du script"
echo ""

if [ $dom = "y" ]
then
echo "Pour la premiere utilisation veuillez accedez a mineweb ici https://$domaine/"
else
echo "Pour la premiere utilisation veuillez accedez a mineweb ici http://$domaine/"
fi
echo "et entrez les identifiant sql se trouvant dans /root/id_mineweb.txt"
echo "=============================="
echo "=============================="
sleep 5
