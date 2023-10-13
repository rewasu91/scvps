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
VERSIONNAME="RKD"
VERSIONNUMBER="TEAM"
timedatectl set-timezone Asia/Kuala_Lumpur

export INFO="[${YELLOW} INFO ${NC}]";
export OKEY="[${GREEN} OKEY ${NC}]";
export PENDING="[${YELLOW} PENDING ${NC}]";
export SEND="[${YELLOW} SEND ${NC}]";
export RECEIVE="[${YELLOW} RECEIVE ${NC}]";

IP=$(wget -qO- icanhazip.com)
dateToday=$(date +"%Y-%m-%d")
DOMAIN_NAME=$(cat /etc/.domain)
PUBLIC_IP=$(cat /etc/.ipaddress)
TOKEN=$(cat /etc/.token)
ChatID=$(cat /etc/.chatid)

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


MYIP=$(curl -sS ipv4.icanhazip.com)
	bottoken=$(cat /etc/.token)
	adminid=$(cat /etc/.chatid)
	echo -e "";
	echo -e ""
	cowsay -f dragon "SELAMAT DATANG BOSKU."
	figlet -k   RKD OTT
	echo -e ""
	laneTop
	echo -e "${keatas} ${bgPutih}                BACKUP OTT USER                ${plain} ${keatas}"
	laneBot
	echo -e "";
	echo -e "[ ${green}INFO${NC} ] Backup data VPS... "
	sleep 1
	echo -e "[ ${green}INFO${NC} ] Create directory... "
	rm -rf /root/backup/ &>/dev/null
	mkdir -p /root/backup/ &>/dev/null
	sleep 1
	echo -e "[ ${green}INFO${NC} ] Starting... "
	echo -e "[ ${green}INFO${NC} ] Please wait, backup in progress.. "
	sleep 1
	cd /root/backup	
	cp -r /etc/kaizensystem/iptv /root/backup/
	cp -r /var/www/html/iptv /root/backup/htmliptv
	cp /etc/nginx/sites-available/default /root/backup/
	cp /etc/passwd /root/backup/
	cp /etc/group /root/backup/
	cp /etc/gshadow /root/backup/
	cp /etc/shadow /root/backup/
	zip -r backup.zip * >/dev/null 2>&1
	cp backup.zip /root/
	cd
	rm -rf /root/backup/
	cd /root/
	mv backup.zip $IP-$dateToday.zip

	echo -e "[ ${green}INFO${NC} ] Sending backup data to Telegram Bot... "
	fileId=$(curl -Ss --request POST \
		--url "https://api.telegram.org/bot${bottoken}/sendDocument?chat_id=${adminid}&caption=Here Your Backup Today : ${dateToday}" \
		--header 'content-type: multipart/form-data' \
		--form document=@"/root/$IP-$dateToday.zip" | grep -o '"file_id":"[^"]*' | grep -o '[^"]*$')

	filePath=$(curl -Ss --request GET \
		--url "https://api.telegram.org/bot${bottoken}/getfile?file_id=${fileId}" | grep -o '"file_path":"[^"]*' | grep -o '[^"]*$')

	curl -Ss --request GET \
		--url "https://api.telegram.org/bot${bottoken}/sendMessage?chat_id=${adminid}&text=File ID(${MYIP})   : <code>${fileId}</code>&parse_mode=html" &>/dev/null
	curl -Ss --request GET \
		--url "https://api.telegram.org/bot${bottoken}/sendMessage?chat_id=${adminid}&text=File Path(${MYIP}) : <code>${filePath}</code>&parse_mode=html" &>/dev/null

	echo -e "[ ${green}INFO${NC} ] Done... "

	rm -rf /root/backup
	rm -r /root/$IP-$dateToday.zip
	sleep 1
