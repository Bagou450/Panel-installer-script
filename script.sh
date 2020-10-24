#!/bin/bash
noir='\e[0;30m'
gris='\e[1;30m'
rouge='\e[0;31m'
rose='\e[1;31m'
vertfonce='\e[0;32m'
vertclair='\e[1;32m'
orange='\e[0;33m'
jaune='\e[1;33m'
bleufonce='\e[0;34m'
bleuclair='\e[1;34m'
violetfonce='\e[0;35m'
violetclair='\e[1;35m'
cyanfonce='\e[0;36m'
cyanclair='\e[1;36m'
grisclair='\e[0;37m'
blanc='\e[1;37m'
neutre='\e[0;m'

is_buster() {
[[ $(lsb_release -d) =~ "buster" ]]
return $?
}
is_stretch() {
[[ $(lsb_release -c) =~ "stretch" ]]
return $?
}
is_ubuntu16() {
[[ $(lsb_release -d) =~ "Ubuntu 16.04" ]]
return $?
}
is_ubuntu18() {
[[ $(lsb_release -d) =~ "Ubuntu 18.04" ]]
return $?
}
is_ubuntu20() {
[[ $(lsb_release -d) =~ "Ubuntu 20.04" ]]
return $?
}
is_centos7() {
[[ $(cat /etc/centos-release) =~ "7" ]]
return $?
}
is_centos8() {
[[ $(cat /etc/centos-release) =~ "8" ]]
return $?
}

if is_stretch; then
echo -e "${violetclair}-----------${neutre}"
echo -e "Vous utilisez Debian 9"
OS="Debian 9"
echo -e "${violetclair}-----------${neutre}"
elif is_buster; then
echo -e "${violetclair}-----------${neutre}"
echo -e "Vous utilisez Debian 10"
OS="Debian 10"
echo -e "${violetclair}-----------${neutre}"
elif is_ubuntu16; then
echo -e "${violetclair}-----------${neutre}"
echo -e "Vous utilisezUbuntu 16.04 LTS"
OS="Ubuntu 16"
echo -e "${violetclair}-----------${neutre}"
elif is_ubuntu18; then
echo -e "${violetclair}-----------${neutre}"
echo -e "Vous utlisisez Ubuntu 18.04 LTS"
OS="Ubuntu 18"
echo -e "${violetclair}-----------${neutre}"
elif is_ubuntu20; then
echo -e "${violetclair}-----------${neutre}"
echo -e "Vous utilisez Ubuntu 20 LTS"
OS="Ubuntu 20"
echo -e "${violetclair}-----------${neutre}"
elif is_centos7; then
echo -e "${violetclair}-----------${neutre}"
echo -e "Vous utilisez Centos 7"
echo -e "Si vous avez vue des erreur a cause de lsb-release au dessus c est normal :)"
OS="Centos 7"
echo -e "${violetclair}-----------${neutre}"
elif is_centos8; then
echo -e "${violetclair}-----------${neutre}"
echo -e "Vous utilisez Centos 8"
echo -e "Si vous avez vue des erreur a cause de lsb-release au dessus c est normal :)"
OS="Centos 8"
echo -e "${violetclair}-----------${neutre}"
else
echo -e "${violetclair}-----------${neutre}"
echo -e "${rouge}System non supporter :) ${neutre}"
echo -e "${violetclair}-----------${neutre}"
exit
fi

while [ "$PANEL_IMPUT" = '' ]; do
    echo "* [1] - Pterodactyl (Demande un vps KVM)"
    echo "* [2] - Pufferpanel V2"
    echo "* [3] - MineWeb"
    echo "* [4] - Azuriom"

    echo ""

    echo -n "* Veulliez sélécionez se que vous voulez installer : "
    read -r PANEL_IMPUT

    if [ "$PANEL_IMPUT" == "1" ]; then
      PANEL="pterodactyl"
    elif [ "$PANEL_IMPUT" == "2" ]; then
      PANEL="pufferpanel"
    elif [ "$PANEL_IMPUT" == "3" ]; then
      PANEL="mineweb"
    elif [ "$PANEL_IMPUT" == "4" ]; then
      PANEL="azuriom"
  else
echo -e "${rouge}Choix invalide ${neutre}"
exit
fi
done
#=========
#Centos 7
#========
if [[ "$PANEL" = 'pterodactyl' && "$OS" = 'Centos 7'  ]]; then
  echo "Pterodactyl + Centos 7"
  yum -y update
  yum install -y curl
echo -e "${violetclair}-----------${neutre}"
echo -e "${rouge}System non supporter :) ${neutre}"
echo -e "${violetclair}-----------${neutre}"
elif [[ "$PANEL" = 'mineweb' && "$OS" = 'Centos 7'  ]]; then
  echo "MineWeb + Centos 7"
 yum -y update
  yum install -y curl
echo -e "${violetclair}-----------${neutre}"
echo -e "${rouge}System non supporter :) ${neutre}"
echo -e "${violetclair}-----------${neutre}"
elif [[ "$PANEL" = 'pufferpanel' && "$OS" = 'Centos 7'  ]]; then
  echo "PufferPanel + Centos 7"
 yum -y update
  yum install -y curl
echo -e "${violetclair}-----------${neutre}"
echo -e "${rouge}System non supporter :) ${neutre}"
echo -e "${violetclair}-----------${neutre}"
elif [[ "$PANEL" = 'azuriom' && "$OS" = 'Centos 7'  ]]; then
  echo "Azuriom + Centos 7 "
 yum -y update
  yum install -y curl
echo -e "${violetclair}-----------${neutre}"
echo -e "${rouge}System non supporter :) ${neutre}"
echo -e "${violetclair}-----------${neutre}"


#========
#Centos 8
#========
elif [[ "$PANEL" = 'pterodactyl' && "$OS" = 'Centos 8' ]]; then
  echo "Pterodactyl + Centos 8"
  yum -y update
  yum install -y curl
echo -e "${violetclair}-----------${neutre}"
echo -e "${rouge}System non supporter :) ${neutre}"
echo -e "${violetclair}-----------${neutre}"
elif [[ "$PANEL" = 'mineweb' && "$OS" = 'Centos 8' ]]; then
  echo "MineWeb + Centos 8"
 yum -y update
  yum install -y curl
echo -e "${violetclair}-----------${neutre}"
echo -e "${rouge}System non supporter :) ${neutre}"
echo -e "${violetclair}-----------${neutre}"
elif [[ "$PANEL" = 'pufferpanel' && "$OS" = 'Centos 8' ]]; then
  echo "PufferPanel + Centos 8"
 yum -y update
  yum install -y curl
echo -e "${violetclair}-----------${neutre}"
echo -e "${rouge}System non supporter :) ${neutre}"
echo -e "${violetclair}-----------${neutre}"
elif [[ "$PANEL" = 'azuriom' && "$OS" = 'Centos 8' ]]; then
  echo "Azuriom + Centos 8"
 yum -y update
  yum install -y curl
echo -e "${violetclair}-----------${neutre}"
echo -e "${rouge}System non supporter :) ${neutre}"
echo -e "${violetclair}-----------${neutre}"
#========
#DEBIAN 9 
#========


elif [[ "$PANEL" = 'pterodactyl' && "$OS" = 'Debian 9' ]]; then
echo "Pterodactyl + Debian 9"
apt update
apt install -y curl
bash <(curl https://ressources.bagou450.com/scripts/debian9/Debian9ptero.sh)
sleep 2

elif [[ "$PANEL" = 'mineweb' && "$OS" = 'Debian 9' ]]; then
echo "MineWeb + Debian 9"
apt update
apt install -y curl
bash <(curl https://ressources.bagou450.com/scripts/debian9/Debian9mineweb.sh)
sleep 2

elif [[ "$PANEL" = 'pufferpanel' && "$OS" = 'Debian 9' ]]; then
echo "PufferPanel + Debian 9"
sleep 2
apt update
apt install -y curl
bash <(curl https://ressources.bagou450.com/scripts/debian9/Debian9pufferpanel.sh)
sleep 2

elif [[ "$PANEL" = 'azuriom' && "$OS" = 'Debian 9' ]]; then
echo "Azuriom + Debian 9"
apt update
apt install -y curl
bash <(curl https://ressources.bagou450.com/scripts/debian9/Debian9azuriom.sh)
sleep 2


#========
#Ubuntu 18.04 
#========


elif [[ "$PANEL" = 'pterodactyl' && "$OS" = 'Ubuntu 18' ]]; then
echo "Pterodactyl + Ubuntu 18.04 LTS"
apt update
apt install -y curl
bash <(curl https://ressources.bagou450.com/scripts/ubuntu18/Ubuntu18ptero.sh)
sleep 2

elif [[ "$PANEL" = 'mineweb' && "$OS" = 'Ubuntu 18' ]]; then
echo "MineWeb + Ubuntu 18.04 LTS"
apt update
apt install -y curl
bash <(curl https://ressources.bagou450.com/scripts/ubuntu18/Ubuntu18mineweb.sh)
sleep 2

elif [[ "$PANEL" = 'pufferpanel' && "$OS" = 'Ubuntu 18' ]]; then
echo "PufferPanel + Ubuntu 18.04 LTS"
sleep 2
apt update
apt install -y curl
bash <(curl https://ressources.bagou450.com/scripts/ubuntu18/Ubuntu18pufferpanel.sh)
sleep 2

elif [[ "$PANEL" = 'azuriom' && "$OS" = 'Ubuntu 18' ]]; then
echo "Azuriom + Ubuntu 18.04 LTS"
apt update
apt install -y curl
bash <(curl https://ressources.bagou450.com/scripts/ubuntu18/Ubuntu18azuriom.sh)
sleep 2



#========
#Debian 10
#========
elif [[ "$PANEL" = 'pterodactyl' && "$OS" = 'Debian 10' ]]; then
  echo "Pterodactyl + Debian 10"
 apt update
 apt install -y curl
bash <(curl https://ressources.bagou450.com/scripts/debian10/Debian10ptero.sh)
sleep 2
elif [[ "$PANEL" = 'mineweb' && "$OS" = 'Debian 10' ]]; then
  echo "MineWeb + Debian 10"
 apt update
 apt install -y curl
bash <(curl https://ressources.bagou450.com/scripts/debian10/Debian10mineweb.sh)
sleep 2
elif [[ "$PANEL" = 'pufferpanel' && "$OS" = 'Debian 10' ]]; then
  echo "PufferPanel + Debian 10"
 apt update
 apt install -y curl
bash <(curl https://ressources.bagou450.com/scripts/debian1/Debian10pufferpanel.sh)
sleep 2
elif [[ "$PANEL" = 'azuriom' && "$OS" = 'Debian 10' ]]; then
  echo "Azuriom + Debian 10"
 apt update
 apt install -y curl
bash <(curl https://ressources.bagou450.com/scripts/debian10/Debian10azuriom.sh)
sleep 2
#========
#Ubuntu 20.04
#========
elif [[ "$PANEL" = 'pterodactyl' && "$OS" = 'Ubuntu 20' ]]; then
  echo "Pterodactyl + Ubuntu 20"
 apt update
 apt install -y curl
bash <(curl https://ressources.bagou450.com/scripts/ubuntu20/Ubuntu20ptero.sh)
sleep 2
elif [[ "$PANEL" = 'mineweb' && "$OS" = 'Ubuntu 20' ]]; then
  echo "MineWeb + Ubuntu 20"
 apt update
 apt install -y curl
bash <(curl https://ressources.bagou450.com/scripts/ubuntu20/Ubuntu20mineweb.sh)
sleep 2
elif [[ "$PANEL" = 'pufferpanel' && "$OS" = 'Ubuntu 20' ]]; then
  echo "PufferPanel + Ubuntu 20"
 apt update
 apt install -y curl
bash <(curl https://ressources.bagou450.com/scripts/ubuntu20/Ubuntu20pufferpanel.sh)
sleep 2
elif [[ "$PANEL" = 'azuriom' && "$OS" = 'Ubuntu 20' ]]; then
  echo "Azuriom + Ubuntu 20"
 apt update
 apt install -y curl
bash <(curl https://ressources.bagou450.com/scripts/ubuntu20/Ubuntu20azuriom.sh)
sleep 2
else
  echo "Erreur veuillez réessayer"
fi

