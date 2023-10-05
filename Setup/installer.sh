#!/bin/bash
#Script IPTV by Kaizen

red='\e[38;1;31m'
green='\e[38;1;32m'
Red="\033[31m"
Green="\033[32m"
yellow='\e[38;1;33m'
blue='\e[38;5;27m'
ungu='\033[0;35m'
purple='\e[38;5;166m'
WhiteB="\e[5;37m"
BlueCyan="\e[38;1;36m"
Green_background="\033[42;37m"
Red_background="\033[41;37m"
bgblue='\e[1;44m'
bgPutih="\e[1;47;30m"
white='\e[0;37m'
plain='\e[0m'
Suffix="\033[0m"
NC='\e[0m'
keatas="${BlueCyan}│${plain}"
ON="${green}ON${plain}"
OFF="${red}OFF${plain}"
jari="${yellow}☞${plain}"

BLUE='\e[1;36m'
PURPLE='\e[1;35m'
GREEN='\e[1;32m'
RED='\e[1;31m'
YELLOW='\e[1;33m'
WHITE='\e[1m'
NOCOLOR='\e[0m'
MYIP=$(ip -4 addr | sed -ne 's|^.* inet \([^/]*\)/.* scope global.*$|\1|p' | awk '{print $1}' | head -1)
PROVIDERS="/etc/dnsmasq/providers.txt"
VERSIONNAME="Silk Road v"
VERSIONNUMBER="3.1"
DNSMASQ_HOST_FINAL_LIST="/etc/dnsmasq/adblock.hosts"
TEMP_HOSTS_LIST="/etc/dnsmasq/list.tmp"

function lane()
{
	echo -e "${BlueCyan}═══════════════════════════════════════════════════${plain}"
}
function laneTop()
{
	echo -e "${BlueCyan}┌─────────────────────────────────────────────────┐${plain}"
}
function laneBot()
{
	echo -e "${BlueCyan}└─────────────────────────────────────────────────┘${plain}"
}
function laneTop1()
{
	echo -e "   ${BlueCyan}┌───────────────────────────────────────────┐${plain}"
}
function laneBot1()
{
	echo -e "   ${BlueCyan}└───────────────────────────────────────────┘${plain}"
}
function laneTop2()
{
	echo -e "     ${BlueCyan}┌───────────────────────────────────────┐${plain}"
}
function laneBot2()
{
	echo -e "     ${BlueCyan}└───────────────────────────────────────┘${plain}"
}

function ctrl_c()
{
	rm -f install > /dev/null 2>&1; rm -f /usr/sbin/tunneling > /dev/null 2>&1; rm -rf /etc/buildings > /dev/null 2>&1; exit 1
}

function LOGO()
{
	clear
	laneTop
	echo -e "${keatas} ${bgPutih}              AUTOSKRIP KAIZENVPS              ${plain} ${keatas}"
	laneBot
	echo -e ""
}

function Credit_KaizenVPS()
{
	echo -e ""
	laneTop
	echo -e "${keatas} ${bgPutih} TERIMA KASIH KERANA MENGGUNAKAN AUTOSKRIP INI ${plain} ${keatas}"
	laneBot
	echo -e ""
	exit 0
}


function isRoot() {
	if [ ${EUID} != 0 ]; then
		echo " You need to run this script as root"
		exit 1
	fi
}

function checkVirt() {
	if [ "$(systemd-detect-virt)" == "openvz" ]; then
		echo "OpenVZ is not supported"
		exit 1
	fi

	if [ "$(systemd-detect-virt)" == "lxc" ]; then
		echo "LXC is not supported (yet)."
		exit 1
	fi
}

function initialCheck() {
	isRoot
	checkVirt
}

# ═══════════════
# // Allow Access
# ═══════════════
function IZINKAN()
{
	BURIQ ()
	{
		curl -sS https://raw.githubusercontent.com/rewasu91/scvpssettings/main/access > /root/tmp
		data=( `cat /root/tmp | grep -E "^### " | awk '{print $2}'` )
		for user in "${data[@]}"
		do
			exp=( `grep -E "^### $user" "/root/tmp" | awk '{print $3}'` )
			d1=(`date -d "$exp" +%s`)
			d2=(`date -d "$biji" +%s`)
			exp2=$(( (d1 - d2) / 86400 ))
		if [[ "$exp2" -le "0" ]]; then
			echo $user > /etc/.$user.ini
		else
			rm -f  /etc/.$user.ini > /dev/null 2>&1
		fi
		done
		rm -f  /root/tmp
	}
	MYIP=$(curl -sS ipv4.icanhazip.com)
	Name=$(curl -sS https://raw.githubusercontent.com/rewasu91/scvpssettings/main/access | grep $MYIP | awk '{print $2}')
	echo $Name > /usr/local/etc/.$Name.ini
	CekOne=$(cat /usr/local/etc/.$Name.ini)
	Bloman ()
	{
		if [ -f "/etc/.$Name.ini" ]; then
			CekTwo=$(cat /etc/.$Name.ini)
				if [ "$CekOne" = "$CekTwo" ]; then
					res="Expired"
				fi
		else
			res="Permission Accepted..."
		fi
	}
	PERMISSION ()
	{
		MYIP=$(curl -sS ipv4.icanhazip.com)
		IZIN=$(curl -sS https://raw.githubusercontent.com/rewasu91/scvpssettings/main/access | awk '{print $4}' | grep $MYIP)
		if [ "$MYIP" = "$IZIN" ]; then
			Bloman
		else
			res="Permission Denied!"
		fi
		BURIQ
	}
	PERMISSION
	if [ "$res" = "Permission Accepted..." ]; then
		echo -ne
	else
		echo -e "${ERROR} Permission Denied!";
		exit 0
	fi
}
IZINKAN

initialCheck

apt update
apt upgrade -y
apt install -y nginx certbot python3-certbot-nginx
apt install -y bc curl resolvconf lsof python vnstat wget zip rclone ufw sshpass jq
apt-get install figlet
apt-get install cowsay fortune-mod -y

[[ ! -e /etc/silkroad ]] && mkdir -p /etc/silkroad
[[ ! -e /etc/silkroad/wgcf ]] && mkdir -p /etc/silkroad/wgcf
[[ ! -e /etc/silkroad/iptv ]] && mkdir -p /etc/silkroad/iptv
wget -q -O /etc/silkroad/iptv/exp.html "http://abidarwish.online/silkroadv${VERSIONNUMBER}/exp.html"
[[ ! -e /etc/silkroad/iptv/userlist.txt ]] && touch /etc/silkroad/iptv/userlist.txt
[[ ! -e /var/www/html/wgcf ]] && mkdir -p /var/www/html/wgcf
[[ ! -e /var/www/html/iptv ]] && mkdir -p /var/www/html/iptv
wget -q -O /var/www/html/iptv/unverified.html "http://abidarwish.online/silkroadv${VERSIONNUMBER}/unverified.html"

COUNTRY=$(curl -s ipinfo.io/country)
VENDOR=$(curl -s ipinfo.io/org | sed 's/ /=/' | cut -d "=" -f2)
CPU=$(cat /proc/cpuinfo | sed -ne 's|^model name.*: \(.*\)$|\1|p' | cut -d ' ' -f1-2)
CPU_CORE=$(lscpu | sed -ne 's|^CPU(s):.* \(.*\)|\1|p')
CPU_MHZ=$(cat /proc/cpuinfo | sed -ne 's|cpu MHz.*: \(.*\)$|\1|p' | cut -d. -f1)
PUBLIC_IP=$(ip -4 addr | sed -ne 's|^.* inet \([^/]*\)/.* scope global.*$|\1|p' | awk '{print $1}' | head -1)

clear
echo
DOMAIN=""
until [[ ! -z ${DOMAIN_NAME} ]] && ping -c 1 ${DOMAIN_NAME} >/dev/null 2>&1; do
        read -p " Sila masukkan domain anda: " DOMAIN_NAME
done
clear
sed -i "s/server_name _;/server_name ${DOMAIN_NAME};/" /etc/nginx/sites-available/default
sed -i 's/^\tgzip on;/\tgzip off;/' /etc/nginx/nginx.con

systemctl enable nginx
systemctl restart nginx

[[ ! -z $(which ufw) ]] && ufw disable && systemctl stop ufw
	if [[ ! -e /etc/letsencrypt/live/${DOMAIN_NAME} ]]; then
		certbot certonly --nginx --agree-tos -d ${DOMAIN_NAME} --register-unsafely-without-email
		chmod +rx /etc/letsencrypt/live
		chmod +rx /etc/letsencrypt/archive
		chmod -R +r /etc/letsencrypt/archive/${DOMAIN_NAME}
fi

NGINX_PORT=80

wget -q -O /etc/silkroad/bugs "http://abidarwish.online/silkroadv3.2/bugs"
sed -i "s/DOMAIN_NAME/${DOMAIN_NAME}/" /etc/silkroad/bugs
sed -i "s/PUBLIC_IP/${PUBLIC_IP}/" /etc/silkroad/bugs
echo -e "COUNTRY=\"${COUNTRY}\"
VENDOR=\"${VENDOR}\"
CPU=\"${CPU}\"
PUBLIC_IP=\"${PUBLIC_IP}\"
DOMAIN_NAME=\"${DOMAIN_NAME}\"
NGINX_PORT=${NGINX_PORT}
VERSION=\"${VERSIONNUMBER}\"
TOKEN=\"${TOKEN}\"
ID=\"${ID}\"" >/etc/silkroad/parameter

rm -rf /root/.config/rclone/rclone.conf
wget -q -O /root/.config/rclone/rclone.conf "https://raw.githubusercontent.com/abidarwish/silkroad/main/rclone.conf"
[[ ! -e /etc/nginx/nginx.conf.bak ]] && cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak
rm -rf /etc/nginx/nginx.conf
wget -q -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/abidarwish/silkroad/main/nginx.conf"
[[ ! -e /etc/nginx/sites-available/default.bak ]] && cp /etc/nginx/sites-available/default /etc/nginx/sites-available/default.bak
rm -rf /etc/nginx/sites-available/default
wget -q -O /etc/nginx/sites-available/default "https://raw.githubusercontent.com/abidarwish/silkroad/main/default"
sed -i "s/NGINX_PORT/${NGINX_PORT}/" /etc/nginx/sites-available/default
sed -i "s/DOMAIN_NAME/${DOMAIN_NAME}/" /etc/nginx/sites-available/default
sed -i "s/PUBLIC_IP/${PUBLIC_IP}/" /etc/nginx/sites-available/default
systemctl restart nginx	
	
wget -q -O /usr/local/sbin/menu https://github.com/rewasu91/scvps/raw/main/Setup/menu.sh
chmod 755 /usr/local/sbin/menu
menu