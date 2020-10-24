#!/bin/bash
echo "=============================="
echo "Centos 7"

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


yum -y update 

yum install -y policycoreutils policycoreutils-python selinux-policy selinux-policy-targeted libselinux-utils setroubleshoot-server setools setools-console mcstrans
yum install -y epel-release http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --disable remi-php54
yum-config-manager --enable remi-php73
echo "# MariaDB 10.2 CentOS repository list - created 2017-07-14 12:40 UT" >> /etc/yum.repos.d/mariadb.repo
echo "# http://downloads.mariadb.org/mariadb/repositories/" >> /etc/yum.repos.d/mariadb.repo
echo "[mariadb]" >> /etc/yum.repos.d/mariadb.repo
echo "name = MariaDB" >> /etc/yum.repos.d/mariadb.repo
echo "baseurl = http://yum.mariadb.org/10.2/centos7-amd64" >> /etc/yum.repos.d/mariadb.repo
echo "gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB" >> /etc/yum.repos.d/mariadb.repo
echo "gpgcheck=1" >> /etc/yum.repos.d/mariadb.repo

curl --silent --location https://rpm.nodesource.com/setup_12.x | bash -
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum update -y




yum install -y MariaDB-common MariaDB-server php php-common php-fpm php-cli php-json php-mysqlnd php-mcrypt php-gd php-mbstring php-pdo php-zip php-bcmath php-dom php-opcache zip unzip tar make gcc g++ python httpd docker.ce wget nodejs
yum install -y --enablerepo=remi redis


curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer


systemctl start mariadb
systemctl enable mariadb
systemctl start redis
systemctl enable redis
systemctl enable php-fpm
systemctl start php-fpm
systemctl enable docker
systemctl start docker


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
		rm -rf /etc/httpd/conf.d/azuriom.conf

echo "<VirtualHost *:80>" >> /etc/httpd/conf.d/azuriom.conf
echo "  ServerName" $domaine >> /etc/httpd/conf.d/azuriom.conf
echo "  RewriteEngine On" >> /etc/httpd/conf.d/azuriom.conf
echo "  RewriteCond %{HTTPS} !=on" >> /etc/httpd/conf.d/azuriom.conf
echo "  RewriteRule ^/?(.*) https://%{SERVER_NAME}/$1 [R,L] " >> /etc/httpd/conf.d/azuriom.conf
echo "</VirtualHost>" >> /etc/httpd/conf.d/azuriom.conf
echo "<VirtualHost *:443>" >> /etc/httpd/conf.d/azuriom.conf
echo "  ServerName" $domaine >> /etc/httpd/conf.d/azuriom.conf
echo "  DocumentRoot "/var/www/azuriom"" >> /etc/httpd/conf.d/azuriom.conf
echo "  AllowEncodedSlashes On" >> /etc/httpd/conf.d/azuriom.conf
echo "  php_value upload_max_filesize 100M" >> /etc/httpd/conf.d/azuriom.conf
echo "  php_value post_max_size 100M" >> /etc/httpd/conf.d/azuriom.conf
echo "  <Directory "/var/www/azuriom">" >> /etc/httpd/conf.d/azuriom.conf
echo "    AllowOverride all" >> /etc/httpd/conf.d/azuriom.conf
echo "  </Directory>" >> /etc/httpd/conf.d/azuriom.conf
echo "  SSLEngine on" >> /etc/httpd/conf.d/azuriom.conf
echo "  SSLCertificateFile /etc/letsencrypt/live/"$domaine"/fullchain.pem" >> /etc/httpd/conf.d/azuriom.conf
echo "  SSLCertificateKeyFile /etc/letsencrypt/live/"$domaine"/privkey.pem" >> /etc/httpd/conf.d/azuriom.conf
echo "</VirtualHost> " >> /etc/httpd/conf.d/azuriom.conf

chmod -R 755 /var/www/azuriom && chown -R apache:apache /var/www/azuriom
a2enmod rewrite
a2enmod ssl
service httpd restart

else
		echo "=============================="

        echo "Vous n'avez pas de nom de domaine certbot ne vas pas s installer"
		echo "=============================="

		sleep 5
				rm -rf /etc/httpd/conf.d/azuriom.conf

echo "<VirtualHost *:80>" >> /etc/httpd/conf.d/azuriom.conf
echo "  ServerName" $domaine >> /etc/httpd/conf.d/azuriom.conf
echo "  DocumentRoot "/var/www/azuriom"" >> /etc/httpd/conf.d/azuriom.conf
echo "  AllowEncodedSlashes On" >> /etc/httpd/conf.d/azuriom.conf
echo "  php_value upload_max_filesize 100M" >> /etc/httpd/conf.d/azuriom.conf
echo "  php_value post_max_size 100M" >> /etc/httpd/conf.d/azuriom.conf
echo "  <Directory "/var/www/azuriom">" >> /etc/httpd/conf.d/azuriom.conf
echo "    AllowOverride all" >> /etc/httpd/conf.d/azuriom.conf
echo "  </Directory>" >> /etc/httpd/conf.d/azuriom.conf
echo "</VirtualHost>" >> /etc/httpd/conf.d/azuriom.conf
a2enmod rewrite
a2enmod ssl
service httpd restart

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
