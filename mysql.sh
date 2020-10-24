#!/bin/bash


bddpass=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w12 | head -n1)
echo "Identifiant SQL" >> /root/sql.txt
echo "Utiliisateur : administrateur"  >> /root/sql.txt
echo "Mot de passe :" >> /root/sql.txt
echo ${bddpass} >> /root/sql.txt
mysql -u root -e "DROP USER administrateur;"
mysql -u root -e "CREATE USER administrateur IDENTIFIED BY '"${bddpass}"';"
mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO administrateur WITH GRANT OPTION;"
