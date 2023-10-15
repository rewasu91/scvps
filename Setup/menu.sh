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

function listAllIptvUser() {
	printf " %-41s %-10s\n" "USER ID" "EXP DATE"
	echo -e "${BlueCyan}═══════════════════════════════════════════════════${plain}";
	TODAY_IN_SECONDS=$(date +%s)
	USER_NUMBER=$(wc -l < /etc/kaizensystem/iptv/userlist.txt)
	cut -d ' ' -f2-3 /etc/kaizensystem/iptv/userlist.txt | cut -d '=' -f2-3 | sed 's/EXP_DATE=//' | sort >/etc/kaizensystem/iptv/userlist.tmp
	if [[ ${USER_NUMBER} == 0 ]]; then
		echo " No users"
		echo
		read -p " Press Enter to continue..."
		cd
		menu
	else
		while IFS= read -r LINE; do
			USERNAME=$(echo $LINE | cut -d ' ' -f1)
			EXP_DATE=$(echo $LINE | cut -d ' ' -f2)
			EXPIRED_DATE_DISPLAY=$(echo $LINE | date -d "${EXP_DATE}" +"%d-%m-%Y")
			DATE_IN_SECONDS=$(date -d "${EXP_DATE}" +%s)
			EXPIRED=$(( ${DATE_IN_SECONDS} - ${TODAY_IN_SECONDS} ))
			if [[ ${EXPIRED} -le 0 ]]; then
				EXP_USER=${USER}
				printf " %-41s ${RED}%-10s${NOCOLOR}\n" "$USERNAME" "$EXPIRED_DATE_DISPLAY"
			else
				printf " %-41s ${GREEN}%-10s${NOCOLOR}\n" "$USERNAME" "$EXPIRED_DATE_DISPLAY"
			fi
		done </etc/kaizensystem/iptv/userlist.tmp
	fi
	echo -e "${BlueCyan}═══════════════════════════════════════════════════${plain}";
	echo -e " Total user: ${USER_NUMBER}"
	echo -e "${BlueCyan}═══════════════════════════════════════════════════${plain}";
	echo
}

function registerProvider() {
	PROVIDER_NAME=""
	LINK=""
	OTT_HASH=""
	clear
	echo -e ""
	cowsay -f dragon "SELAMAT DATANG BOSKU."
	figlet -k   RKD OTT
	echo -e ""
	laneTop
	echo -e "${keatas} ${bgPutih}             REGISTER IPTV PROVIDER             ${plain} ${keatas}"
	laneBot
	echo
	if [[ $(systemctl is-active warp-svc) == "inactive" ]]; then
		echo -e " ${RED}WARP Proxy is not running. Please start it first${NOCOLOR}"
		echo
		read -p " Press Enter to continue..."
		menu
	fi
	clear
	echo -e ""
	cowsay -f dragon "SELAMAT DATANG BOSKU."
	figlet -k   RKD OTT
	echo -e ""
	laneTop
	echo -e "${keatas} ${bgPutih}             REGISTER IPTV PROVIDER             ${plain} ${keatas}"
	laneBot
	printf " %-41s %-10s\n" "PROVIDER" "URL"
	echo -e "${BlueCyan}═══════════════════════════════════════════════════${plain}";
	[[ ! -e /etc/kaizensystem/iptv/providerlist.txt ]] && touch /etc/kaizensystem/iptv/providerlist.txt
	if [[ -z $(cat /etc/kaizensystem/iptv/providerlist.txt) ]]; then
		echo -e " No provider"
	fi
	while IFS= read -r LINE; do
		PROVIDER_NAME=$(echo ${LINE} | awk '{print $1}')
		URL=$(echo ${LINE} | awk '{print $2}')
		printf " %-41s %-10s\n" "${PROVIDER_NAME}" "${URL}"
	done </etc/kaizensystem/iptv/providerlist.txt
	echo
	until [[ ! -z ${LINK} ]]; do
		read -p " Type provider's URL (press c to cancel): " LINK
		[[ ${LINK,,} == "c" ]] && menu
	done
	if [[ $(grep -c -w "${LINK}" /etc/kaizensystem/iptv/providerlist.txt) != 0 ]]; then
		echo -e " Provider already registered"
		read -p " Do you want to delete it? [y/n]: " DEL_PROVIDER
		if [[ ${DEL_PROVIDER,,} == "y" ]]; then
			PROVIDER=$(grep -w "${LINK}" /etc/kaizensystem/iptv/providerlist.txt | awk '{print $1}')
			echo -n -e " Deleting ${PROVIDER}..."
			cp -f /etc/kaizensystem/iptv/providerlist.txt /etc/kaizensystem/iptv/providerlist.txt.bak
			mv /etc/kaizensystem/iptv/${PROVIDER}.playlist /etc/kaizensystem/iptv/${PROVIDER}.playlist.bak
			rm -rf /var/www/html/iptv/${PROVIDER}.txt
			sed -i "/^${PROVIDER}/d" /etc/kaizensystem/iptv/providerlist.txt
			sleep 2
			echo -n -e "${GREEN}done${NOCOLOR}"
			sleep 1
			registerProvider
		else
			registerProvider
		fi
	fi
	until [[ ! -z ${PROVIDER_NAME} && $(grep -c -w "${PROVIDER_NAME}" /etc/kaizensystem/iptv/providerlist.txt) == 0 ]]; do
		read -p " Type provider name (press c to cancel): " PROVIDER_NAME
		[[ ${PROVIDER_NAME,,} == "c" ]] && menu
	done
	until [[ ! -z ${OTT_HASH} ]]; do
		read -p " OTT hash (press c to cancel): " OTT_HASH
		#read -rp " OTT hash (press c to cancel): " -e -i "\"paste within this quote\"" OTT_HASH
		[[ ${OTT_HASH,,} == "c" ]] && menu
	done
	#until [[ $(echo "${OTT_HASH}" | grep -c "\"") != 0 && $(echo "${OTT_HASH}" | grep -c -w "OTT") != 0 ]]; do
	#echo -e " ${RED}Invalid OTT hash${NOCOLOR}"
	#	read -p " OTT hash (press c to cancel): " OTT_HASH
		#read -rp " OTT hash (press c to cancel): " -e -i "\"paste within this quote\"" OTT_HASH
		[[ ${OTT_HASH,,} == "c" ]] && menu
	#done
	OTT=$(echo ${OTT_HASH} | sed 's/"//g')
	read -p " Type EPG URL (just press Enter if not sure): " EPG
	if [[ -z ${EPG} ]]; then
		echo -n -e " Searching internet for a reliable EPG..."
		EPG_URL=$(wget -q -O - http://tny.im/yourls-api.php?action=shorturl\&format=simple\&url="https://raw.githubusercontent.com/AqFad2811/epg/main/astro.xml"\&keyword=$2)
		EPG=$(echo ${EPG_URL})
		sleep 1
		echo -e "${GREEN}done${NOCOLOR}"
	else
		echo -n -e " Preparing EPG..."
		EPG_URL=$(wget -q -O - http://tny.im/yourls-api.php?action=shorturl\&format=simple\&url="${EPG}"\&keyword=$2)
		EPG=$(echo ${EPG_URL})
		sleep 1
		echo -e "${GREEN}done${NOCOLOR}"
	fi
	echo -n -e " Sniffing ${PROVIDER_NAME} playlist..."
	#curl -x socks5h://127.0.0.1:40000 -sL -o /etc/kaizensystem/iptv/${PROVIDER_NAME}.playlist.tmp "${LINK}" -A "OTT Navigator/1.6.8.3 (Linux;Android 11; en; ${OTT_HASH})"
	
	curl -x socks5h://127.0.0.1:40000 -sL -o /etc/kaizensystem/iptv/${PROVIDER_NAME}.playlist.tmp "${LINK}" -A "${OTT}"
	
	#if [[ -z $(grep "Warna" /etc/kaizensystem/iptv/${PROVIDER_NAME}.playlist.tmp) || -z $(grep "Arena Bola" /etc/kaizensystem/iptv/${PROVIDER_NAME}.playlist.tmp) ]]; then
	#	echo
	#	echo -e " ${RED}Error while extracting ${PROVIDER_NAME} playlist${NOCOLOR}"
	#	echo
	#	read -p " Press Enter to continue..."
	#	registerProvider
	#fi
	mv /etc/kaizensystem/iptv/${PROVIDER_NAME}.playlist.tmp /etc/kaizensystem/iptv/${PROVIDER_NAME}.playlist
	cp -f /etc/kaizensystem/iptv/${PROVIDER_NAME}.playlist /var/www/html/iptv/${PROVIDER_NAME}.txt
	cp -f /etc/kaizensystem/iptv/${PROVIDER_NAME}.playlist /etc/kaizensystem/iptv/kaizensystem.playlist
	#sed -i "/^${PROVIDER_NAME}/d" /etc/kaizensystem/iptv/providerlist.txt
	#sed -i '/^$/d' /etc/kaizensystem/iptv/providerlist.txt
	echo "${PROVIDER_NAME} ${LINK} ${OTT}">>/etc/kaizensystem/iptv/providerlist.txt 
	#sed -i '/^EPG/d' /etc/kaizensystem/parameter
	#sed -i '/^$/d' /etc/kaizensystem/parameter
	echo "EPG=${EPG}">>/etc/kaizensystem/parameter
	echo -n -e "${GREEN}done${NOCOLOR}"
	sleep 1
	clear
	echo
	echo -e " Download ${PROVIDER_NAME} playlist from:
 http://${DOMAIN_NAME}/iptv/${PROVIDER_NAME}.txt"
	echo
	read -p " Press Enter to continue..."
	registerProvider
}

function createIptvUser() {
	source /etc/kaizensystem/parameter
	clear
	echo -e ""
	cowsay -f dragon "SELAMAT DATANG BOSKU."
	figlet -k   RKD OTT
	echo -e ""
	laneTop
	echo -e "${keatas} ${bgPutih}               CREATE IPTV USER                ${plain} ${keatas}"
	laneBot
	printf " %-41s %-10s\n" "USER ID" "EXP DATE"
	echo -e "${BlueCyan}═══════════════════════════════════════════════════${plain}";
	if [[ ! -e /etc/kaizensystem/iptv/providerlist.txt || -z $(cat /etc/kaizensystem/iptv/providerlist.txt) ]]; then
		echo -e " Please register provider first"
		echo
		read -p " Press Enter to continue..."
		menu
	fi
	TODAY_IN_SECONDS=$(date +%s)
	USER_NUMBER=$(wc -l < /etc/kaizensystem/iptv/userlist.txt)
	#USER_NUMBER=$(ls -w 1 /etc/kaizensystem/wgcf | sed '/version.txt/d')
	#USER_NUMBER="$(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/kaizensystem/iptv/userlist.txt | wc -l)";	
	cut -d ' ' -f2-3 /etc/kaizensystem/iptv/userlist.txt | cut -d '=' -f2-3 | sed 's/EXP_DATE=//' | sort >/etc/kaizensystem/iptv/userlist.tmp 
	if [[ ${USER_NUMBER} == 0 || ! -e /etc/kaizensystem/iptv/userlist.txt ]]; then
		echo " No users"
	else
		while IFS= read -r LINE; do
			USERNAME=$(echo $LINE | cut -d ' ' -f1)
			EXP_DATE=$(echo $LINE | cut -d ' ' -f2)
			EXPIRED_DATE_DISPLAY=$(echo $LINE | date -d "${EXP_DATE}" +"%d-%m-%Y")
			DATE_IN_SECONDS=$(date -d "${EXP_DATE}" +%s)
			EXPIRED=$(( ${DATE_IN_SECONDS} - ${TODAY_IN_SECONDS} ))
			if [[ ${EXPIRED} -le 0 ]]; then
				printf " %-41s ${RED}%-10s${NOCOLOR}\n" "$USERNAME" "$EXPIRED_DATE_DISPLAY"
			else
				printf " %-41s ${GREEN}%-10s${NOCOLOR}\n" "$USERNAME" "$EXPIRED_DATE_DISPLAY"
			fi
		done </etc/kaizensystem/iptv/userlist.tmp
		echo -e "${BlueCyan}═══════════════════════════════════════════════════${plain}";
		echo -e " Total user: ${USER_NUMBER}"
		echo -e "${BlueCyan}═══════════════════════════════════════════════════${plain}";
	fi
	echo
	read -p " Create username or press c to cancel: " USERNAME
	[[ ${USERNAME,,} == "c" ]] && menu
	if [[ $(cat /etc/kaizensystem/iptv/userlist.txt | grep -c -w "${USERNAME}") != 0 ]]; then
		echo -e " ${USERNAME} is already existed"
		echo
		read -p " Press Enter to try again..."
		createIptvUser
	fi
	read -p " Expired (days): " ACTIVE
	[[ -z ${ACTIVE} ]] && ACTIVE=1
	EXPIRED_DATE=$(date -d "${ACTIVE} days" +"%Y-%m-%d")
	EXPIRED_DATE_DISPLAY=$(date -d "${EXPIRED_DATE}" +"%d-%m-%Y")
	UUID=$(xray uuid)
	#UUID=$(uuidgen -r)
	#UUID=${USERNAME}
	#clear
	#echo
	#echo -e " ${WHITE}List of Provider${NOCOLOR}"
	# printf " %-41s %-10s\n" "PROVIDER" "URL"
	# echo -e "${BlueCyan}═══════════════════════════════════════════════════${plain}";
	#while IFS= read -r LINE; do
		#PROVIDER_NAME=$(echo ${LINE} | awk '{print $1}')
		#URL=$(echo ${LINE} | awk '{print $2}')
		# printf " %-15s %-10s\n" "${PROVIDER_NAME}" "${URL}"
		#printf " %-15s\n" "${PROVIDER_NAME}"
	#done </etc/kaizensystem/iptv/providerlist.txt
	#echo
	#read -p " Select provider or press c to cancel: " PROVIDER_NAME
	#[[ ${PROVIDER_NAME,,} == "c" ]] && menu
	#[[ -z ${PROVIDER_NAME} ]] && createIptvUser
	#if [[ $(grep -c -w "${PROVIDER_NAME}" /etc/kaizensystem/iptv/providerlist.txt) == 0 ]]; then
		#echo -e " Provider not exist"
		#echo
		#read -p " Press Enter to continue..."
		#createIptvUser
	#fi
	#PLAYLIST="/etc/kaizensystem/iptv/${PROVIDER_NAME}.playlist"
	#PLAYLIST="/etc/kaizensystem/iptv/ovesta123.playlist"
	
	clear
	echo
	echo -e " ${WHITE}List of Provider${NOCOLOR}"
	NUMBER_OF_PROVIDER=$(cat /etc/kaizensystem/iptv/providerlist.txt | cut -d ' ' -f1 | wc -l)
	
	cat /etc/kaizensystem/iptv/providerlist.txt | cut -d ' ' -f1 | nl -s '] ' -w1 | sed 's/^/ \[/'

	ADDITIONAL_MENU=$(( ${NUMBER_OF_PROVIDER} + 1 ))
	
	echo -e " [${ADDITIONAL_MENU}] Main menu"
	
	echo
	echo -n -e " Enter option [1-${ADDITIONAL_MENU}]"
	read -p ": " PROVIDER_NUMBER
	[[  ${PROVIDER_NUMBER} == ${ADDITIONAL_MENU} ]] && menu
	echo -n -e " Sending user account details to Telegram Bot..."
	PROVIDER_NAME=$(cat /etc/kaizensystem/iptv/providerlist.txt | cut -d ' ' -f1 | sed -n "${PROVIDER_NUMBER}"p)
	PLAYLIST="/etc/kaizensystem/iptv/${PROVIDER_NAME}.playlist"
	sed -i '/EXTM3U billed-msg/d' ${PLAYLIST}
	sed -i "1i \#EXTM3U billed-msg=\"${VERSIONNAME}${VERSIONNUMBER}     \|     Last updated on ${DATE_DISPLAY}\"" ${PLAYLIST}
	cp -f ${PLAYLIST} /var/www/html/iptv/${UUID}.html
	URL="http://${DOMAIN_NAME}/iptv/${UUID}.html"
	SHORT_URL=$(wget -q -O - http://tny.im/yourls-api.php?action=shorturl\&format=simple\&url=${URL}\&keyword=$2)
	URL_SHORTENED=$(echo ${SHORT_URL})
	echo "UUID=${UUID} USERNAME=${USERNAME} EXP_DATE=${EXPIRED_DATE} URL=${URL_SHORTENED} PROVIDER_NAME=${PROVIDER_NAME}" >>/etc/kaizensystem/iptv/userlist.txt
	TOKEN=$(cat /etc/.token)
	ChatID=$(cat /etc/.chatid)
	TEXT="<b>══════════════════</b>
	<b>💎 RKD OTT PREMIUM 💎</b>
	<b>══════════════════</b>

<b>📌 MAKLUMAT AKAUN</b>
🎭 Username%3A ${USERNAME}
⏰ Expired Date%3A ${EXPIRED_DATE_DISPLAY}

<b>📌 OTT NAVIGATOR PLAYLIST URL</b>
🔗 ${URL_SHORTENED}

<b>📌 OTT NAVIGATOR EPG URL (CHANNEL INFO)</b>
🔗 ${EPG}

<b>📌 LINK DOWNLOAD APPS OTT NAVIGATOR</b>
<a href=\"https://shorturl.at/mzEF6\"><b>🔗 Download di sini</b></a>

<b>⚙️ SILA IKUT STEP INI </b>
1. Sila copy URL ini ${URL_SHORTENED}
2. Masukkan URL yang telah dicopy kedalam apps OTT. <a href=\"https://youtu.be/asRn2XMkYck\"><b>CARA MASUKKAN URL</b></a>
3. Selepas dah masukkan URL dan apply, sila pm admin semula untuk verify device anda. PM admin, "Done Login"
4. Admin akan verify device anda. Selepas admin dah verify device anda, sila refresh URL. <a href=\"https://www.youtube.com/watch?v=5cOAOOCHBqc\"><b>CARA REFRESH URL</b></a>
5. Selepas dah refresh, anda dah boleh mula menonton tv dan movie sepuas hati anda. Enjoy!

<b>⚙️ PANDUAN APPS OTT NAVIGATOR </b>
├📺<a href=\"https://youtu.be/asRn2XMkYck\"><b> Cara masukkan URL Playlist</b></a>
├📺<a href=\"https://youtu.be/_krHpiJfBzo\"><b> Cara setting EPG</b></a>
├📺<a href=\"https://www.youtube.com/watch?v=zLvd0uZ1XRQ\"><b> Cara setting audio subtitle</b></a>
├📺<a href=\"https://www.youtube.com/watch?v=5cOAOOCHBqc\"><b> Cara refresh atau reload URL</b></a>
├📺<a href=\"https://www.youtube.com/watch?v=GVIUoArZFis\"><b> Cara setting resolution OTT</b></a>
├📺<a href=\"https://www.youtube.com/watch?v=8idoboRhDAg\"><b> Cara setting OTT di Android Box</b></a>

<b>⚙️ CARA SETUP VOD MOVIE</b>
├📺 Masuk ke Setting OTT Navigator.
├📺 Tekan Media Library.
├📺 Kemudian tekan Reload Data.
├📺 Selesai ✅.

<b>🚫 PANTANG LARANG</b>
‼️ SATU URL hanya untuk satu device sahaja. Untuk device tambahan, sila langgan URL berasingan.
‼️ URL yang cuba dimasukkan ke dalam device selain daripada device yang telah disahkan (verified), akaun anda akan disekat dan tiada refund.
‼️ DILARANG scan/sniff playlist. Sekiranya didapati scann/sniff playlist, akaun anda akan disekat dan tiada refund.
"
	curl -s --data "parse_mode=HTML" --data "text=${TEXT}" --data "chat_id=${ChatID}" --request POST 'https://api.telegram.org/bot'${TOKEN}'/sendMessage' >/dev/null 2>&1

	OTT_UUID=$(xray uuid | cut -d '-' -f1)
	sed -i '/^}/d' /etc/nginx/sites-available/default
	echo -e "\n\tlocation = /iptv/${UUID}.html {
\t\tif (\$http_user_agent != \"OTT Navigator/1.6.8.3 (Linux;Android 11; en; ${OTT_UUID})\") { # UUID=${UUID}
\t\t\trewrite ^ http://${DOMAIN_NAME}/iptv/unverified.html last;
\t\t}
\t}
}">>/etc/nginx/sites-available/default
	echo -n -e "${GREEN}done${NOCOLOR}"
	#systemctl restart nginx
	nginx -s reload
	menu
}

function verifyOTTID() {
	clear
	echo
	echo -e " ${WHITE}Verify User${NOCOLOR}"
	echo -e "${BlueCyan}═══════════════════════════════════════════════════${plain}";
	cut -d ' ' -f2 /etc/kaizensystem/iptv/userlist.txt | cut -d '=' -f2 | sort >/etc/kaizensystem/iptv/userlist.tmp 
	if [[ -z $(cat /etc/kaizensystem/iptv/userlist.txt) ]]; then
		echo -e " No user"
		echo
		read -p " Press Enter to continue..."
		menu
	else
		while IFS= read -r LINE; do
			USERNAME=$(echo $LINE | awk '{print $1}')
			UUID=$(grep -w "${USERNAME}" /etc/kaizensystem/iptv/userlist.txt | sed -ne 's|^UUID=\(.*\) USERNAME.*$|\1|p')
			OTT_ID_CONF=$(sed -ne "s|^.*$http_user_agent != \"\(.*\)\".* UUID=${UUID}$|\1|p" /etc/nginx/sites-available/default)
			OTT_ID_LOG=$(sed -ne "s|^.*/iptv/${UUID}.html.* \"-\" \"\(.*\)\"$|\1|p" /var/log/nginx/access.log | grep OTT | tail -1)
			OTT_HASH=$(echo ${OTT_ID_LOG} | cut -d ' ' -f6 | sed 's/)//')
			OTT_ID=$(echo ${OTT_ID_LOG})
			if [[ -z ${OTT_ID_LOG} ]]; then
				printf " %-1s ${RED}%-10s${NOCOLOR}\n" "$USERNAME" "${OTT_ID_CONF}"
			else
				if [[ ${OTT_ID_CONF} != ${OTT_ID_LOG} && $(echo "${OTT_HASH}" | wc -l) -ge 8 ]]; then
					printf " %-1s ${BLUE}%-10s${NOCOLOR}\n" "${USERNAME}" "${OTT_ID}"
				elif [[ ${OTT_ID_CONF} != ${OTT_ID_LOG} && $(echo "${OTT_HASH}" | wc -l) -lt 8 ]]; then
					printf " %-1s ${YELLOW}%-10s${NOCOLOR}\n" "${USERNAME}" "${OTT_ID}"
				else
					printf " %-1s ${GREEN}%-10s${NOCOLOR}\n" "${USERNAME}" "${OTT_ID}"
				fi
			fi
		done </etc/kaizensystem/iptv/userlist.tmp
	fi
	echo -e "${BlueCyan}═══════════════════════════════════════════════════${plain}";
	echo
	read -p " Select username or press c to cancel: " USERNAME
	[[ -z ${USERNAME} ]] && verifyOTTID
	[[ ${USERNAME,,} == "c" ]] && menu
	if [[ $(grep -w -c "USERNAME=${USERNAME}" /etc/kaizensystem/iptv/userlist.txt) == 0 ]]; then
		echo -e " ${USERNAME} does no exist"
		echo
		read -p " Press Enter to try again..."
		verifyOTTID
	fi
	UUID=$(grep -w "${USERNAME}" /etc/kaizensystem/iptv/userlist.txt | sed -ne "s|.*UUID=\(.*\) USERNAME.*$|\1|p")
	OTT_ID_CONF=$(sed -ne "s|^.*$http_user_agent != \"\(.*\)\".* UUID=${UUID}$|\1|p" /etc/nginx/sites-available/default)
	OTT_ID_LOG=$(sed -ne "s|^.*/iptv/${UUID}.html.* \"-\" \"\(.*\)\"$|\1|p" /var/log/nginx/access.log | grep OTT | tail -1)
	if [[ -z ${OTT_ID_LOG} ]]; then
		echo -e " ${USERNAME} is offline"
		echo
		read -p " Press Enter to continue..."
		verifyOTTID
	else
		if [[ ${OTT_ID_CONF} == ${OTT_ID_LOG} ]]; then
			echo -e " ${USERNAME} has already been verified"
			echo
			read -p " Press Enter to continue..."
			verifyOTTID
		else
			sed -i "s|${OTT_ID_CONF}|${OTT_ID_LOG}|" /etc/nginx/sites-available/default
			echo -n -e " Verifying ${USERNAME}..."
			#systemctl restart nginx
			nginx -s reload
			echo -e "${GREEN}done${NOCOLOR}"
			sleep 1
			verifyOTTID
		fi
	fi
}

function renewIPTVUser() {
	clear
	echo -e ""
	cowsay -f dragon "SELAMAT DATANG BOSKU."
	figlet -k   RKD OTT
	echo -e ""
	laneTop
	echo -e "${keatas} ${bgPutih}               RENEW IPTV USER                 ${plain} ${keatas}"
	laneBot
	listAllIptvUser
	read -p " Select username or press c to cancel: " USERNAME
	if [[ ${USERNAME,,} = "c" ]]; then
		menu
	fi
	if [[ -z $USERNAME || $(grep -c -w "${USERNAME}" /etc/kaizensystem/iptv/userlist.txt) == 0 ]]; then
		echo -e " ${RED}Incorrect username${NOCOLOR}"
		echo
		read -p " Press Enter to try again..."
		renewIPTVUser
	fi

	read -p " Expired (days): " ACTIVE
	[[ -z ${ACTIVE} ]] && ACTIVE=1

	OLD_EXPIRED_DATE=$(sed -ne "s|.*USERNAME=${USERNAME} EXP_DATE=\(.*\) URL.*$|\1|p" /etc/kaizensystem/iptv/userlist.txt)
	NEW_EXPIRED_DATE=$(date -d "${ACTIVE} days" +"%Y-%m-%d")
	EXPIRED_DATE_DISPLAY=$(date -d "$NEW_EXPIRED_DATE" +"%d-%m-%Y")
	UUID=$(sed -ne "s|.*UUID=\(.*\) USERNAME=${USERNAME} EXP_DATE.*$|\1|p" /etc/kaizensystem/iptv/userlist.txt)
	URL=$(sed -ne "s|.*${USERNAME} EXP_DATE.* URL=\(.*\) PROVIDER_NAME.*$|\1|p" /etc/kaizensystem/iptv/userlist.txt)

	sed -i "s|UUID=${UUID} USERNAME=${USERNAME} EXP_DATE=${OLD_EXPIRED_DATE}|UUID=${UUID} USERNAME=${USERNAME} EXP_DATE=${NEW_EXPIRED_DATE}|" /etc/kaizensystem/iptv/userlist.txt 
	sed -E -i "s|^#UUID=${UUID} USERNAME=${USERNAME} EXP_DATE=${OLD_EXPIRED_DATE}|UUID=${UUID} USERNAME=${USERNAME} EXP_DATE=${NEW_EXPIRED_DATE}|" /etc/kaizensystem/iptv/userlist.txt
	
	cp -f /etc/kaizensystem/iptv/kaizensystem.playlist /var/www/html/iptv/${UUID}.html

	clear
	echo
	echo -e " ${WHITE}User Account Details${NOCOLOR}
 Username: $USERNAME
 Expired date: $EXPIRED_DATE_DISPLAY
 OTT Nav URL: ${URL}"
	echo
	read -p " Press Enter to continue..."
	renewIPTVUser
}

#function revokesIptv() {
#	while IFS= read -r LINE; do
#		EXP_DATE=$(echo $LINE | sed -ne 's|.*EXP_DATE=\(.*\) URL.*$|\1|p')
#		UUID=$(echo $LINE | sed -ne "s|^UUID=\(.*\) USERNAME.*${EXP_DATE}.*$|\1|p")
#		USERNAME=$(echo $LINE | sed -ne "s|.*${UUID} USERNAME=\(.*\) EXP_DATE.*$|\1|p")
#		EXP_DATE_IN_SECOND=$(date -d "${EXP_DATE}" +"%s")
#		EXPIRED=$(( EXP_DATE_IN_SECOND - TODAY ))
#		if [[ $EXPIRED -le 0 ]]; then
#			cp -f /etc/kaizensystem/iptv/exp.html /var/www/html/iptv/${UUID}.html
#			echo -e ${USERNAME}
#		fi
#	done < /etc/kaizensystem/iptv/userlist.txt
#	rm -rf /var/log/letsencrypt/letsencrypt.log*
#}

function delIptvUser() {
	clear
	echo -e ""
	cowsay -f dragon "SELAMAT DATANG BOSKU."
	figlet -k   RKD OTT
	echo -e ""
	laneTop
	echo -e "${keatas} ${bgPutih}               DELETE IPTV USER                ${plain} ${keatas}"
	laneBot
	listAllIptvUser
	read -p " Select username or press c to cancel: " USERNAME
	if [[ ${USERNAME,,} = c ]]; then
		menu
	fi
	if [[ -z ${USERNAME} || $(grep -c -w "${USERNAME}" /etc/kaizensystem/iptv/userlist.txt) == 0 ]]; then
		echo -e " ${RED}Incorrect username${NOCOLOR}"
		echo
		read -p " Press Enter to try again..."
		delIptvUser
	fi
	
	UUID=$(grep -w "${USERNAME}" /etc/kaizensystem/iptv/userlist.txt | sed -ne "s|.*UUID=\(.*\) USERNAME.*$|\1|p")
	
	sed -i "/UUID=${UUID} USERNAME=${USERNAME}/d" /etc/kaizensystem/iptv/userlist.txt
	sed -i "/^#UUID=${UUID} USERNAME=${USERNAME}/d" /etc/kaizensystem/iptv/userlist.txt
	sed -i "/\/iptv\/${UUID}.html/,/^\t}/d" /etc/nginx/sites-available/default	
	sed -i '/^$/d' /etc/nginx/sites-available/default
	cp -f /etc/kaizensystem/iptv/exp.html /var/www/html/iptv/${UUID}.html
	#rm -rf /var/www/html/iptv/${UUID}.html
	echo -e " ${GREEN}ID has been deleted${NOCOLOR}"
    echo
	read -p " Press Enter to continue..."
	nginx -s reload
	delIptvUser
}

function listIptvUser() {
	source /etc/kaizensystem/parameter
	printf " %-41s %-10s\n" "USER ID" "EXP DATE"
	echo -e "${BlueCyan}═══════════════════════════════════════════════════${plain}";
	TODAY_IN_SECONDS=$(date +%s)
	USER_NUMBER=$(wc -l < /etc/kaizensystem/iptv/userlist.txt)
	cut -d ' ' -f2-3 /etc/kaizensystem/iptv/userlist.txt | cut -d '=' -f2-3 | sed 's/EXP_DATE=//' | sort >/etc/kaizensystem/iptv/userlist.tmp
	if [[ ${USER_NUMBER} == 0 ]]; then
		echo " No users"
		echo
		read -p " Press Enter to continue..."
		cd
		menu
	else
		while IFS= read -r LINE; do
			USERNAME=$(echo $LINE | cut -d ' ' -f1)
			EXP_DATE=$(echo $LINE | cut -d ' ' -f2)
			EXPIRED_DATE_DISPLAY=$(echo $LINE | date -d "${EXP_DATE}" +"%d-%m-%Y")
			DATE_IN_SECONDS=$(date -d "${EXP_DATE}" +%s)
			EXPIRED=$(( ${DATE_IN_SECONDS} - ${TODAY_IN_SECONDS} ))
			if [[ ${EXPIRED} -le 0 ]]; then
				EXP_USER=${USER}
				printf " %-41s ${RED}%-10s${NOCOLOR}\n" "$USERNAME" "$EXPIRED_DATE_DISPLAY"
			else
				printf " %-41s ${GREEN}%-10s${NOCOLOR}\n" "$USERNAME" "$EXPIRED_DATE_DISPLAY"
			fi
		done </etc/kaizensystem/iptv/userlist.tmp
	fi
	echo -e "${BlueCyan}═══════════════════════════════════════════════════${plain}";
	echo -e " Total user: ${USER_NUMBER}"
	echo -e "${BlueCyan}═══════════════════════════════════════════════════${plain}";
	echo
	read -p " Select username or press c to cancel: " USERNAME
	[[ ${USERNAME,,} = c ]] && menu
	if [[ -z ${USERNAME} || $(grep -c -w "${USERNAME}" /etc/kaizensystem/iptv/userlist.txt) == 0 ]]; then
		echo -e " ${RED}Incorrect username${NOCOLOR}"
		echo
		read -p " Press Enter to try again..."
		delIptvUser
	fi
	
	UUID=$(sed -ne "s|.*UUID=\(.*\) USERNAME=${USERNAME} EXP_DATE.*$|\1|p" /etc/kaizensystem/iptv/userlist.txt)
	EXP_DATE=$(sed -ne "s|.*USERNAME=${USERNAME} EXP_DATE=\(.*\) URL.*$|\1|p" /etc/kaizensystem/iptv/userlist.txt)
	EXPIRED_DATE_DISPLAY=$(date -d "${EXP_DATE}" +"%d-%m-%Y")
	
	URL=$(sed -ne "s|.*${UUID}.* URL=\(.*\) PROVIDER_NAME.*$|\1|p" /etc/kaizensystem/iptv/userlist.txt)

	clear
	echo -e ""
	cowsay -f dragon "SELAMAT DATANG BOSKU."
	figlet -k   RKD OTT
	echo -e ""
	laneTop
	echo -e "${keatas} ${bgPutih}                 IPTV USER INFO                 ${plain} ${keatas}"
	laneBot
	echo -e " ${WHITE}User Account Details${NOCOLOR}
 Username     : ${USERNAME}
 Expired date : ${EXPIRED_DATE_DISPLAY}

 OTT Navigator playlist URL:
 ${URL}
 
 EPG URL is as below:
 ${EPG}"
	echo
	read -p " Press Enter to continue..."
	listIptvUser
}

function checkIptvAbuse() {
	clear
	echo -e ""
	cowsay -f dragon "SELAMAT DATANG BOSKU."
	figlet -k   RKD OTT
	echo -e ""
	laneTop
	echo -e "${keatas} ${bgPutih}                CHECK USER ABUSE                ${plain} ${keatas}"
	laneBot
	printf " %-17s %-21s %5s\n" "USER" "DEVICE" "STATUS"
	echo " ----------------------------------------------"
	#cat /var/log/nginx/access.log.1 >/var/log/nginx/check.log
	cat /var/log/nginx/access.log >>/var/log/nginx/check.log
	sed -ne 's|.*iptv/\(.*\).html.*; \(.*\))"$|\1 \2|p' /var/log/nginx/check.log | sed '/unverified/d' | sed '/^exp/d' | sort | uniq >/etc/kaizensystem/iptv/user_access.txt
	if [[ $(cat /etc/kaizensystem/iptv/user_access.txt | sed '/^$/d' | wc -l) == 0 ]]; then
		echo
		echo -e " No online users"
		echo
		echo " ----------------------------------------------"
		echo -e " Total device: 0"
		echo " ----------------------------------------------"
		echo
		read -p " Press Enter to continue..."
		menu
	fi
	while IFS= read -r LINE; do
		FILE_ID=$(echo ${LINE} | cut -d' ' -f1)
		USERNAME=$(grep -w "${FILE_ID}" /etc/kaizensystem/iptv/userlist.txt | sed -ne "s|.*USERNAME=\(.*\) EXP_DATE.*$|\1|p")
		DEVICE_ID=$(echo ${LINE} | cut -d' ' -f2)
		if [[ $(grep -c -w "${FILE_ID}" /etc/kaizensystem/iptv/user_access.txt) > 1 ]]; then
			printf " %-17s %-21s ${RED}%-10s${NOCOLOR}\n" "${USERNAME}" "${DEVICE_ID}" "alert"
		else
			printf " %-17s %-21s ${GREEN}%-10s${NOCOLOR}\n" "${USERNAME}" "${DEVICE_ID}" "online"
		fi
	done </etc/kaizensystem/iptv/user_access.txt
	echo " ----------------------------------------------"
	echo -e " Total device: $(cat /etc/kaizensystem/iptv/user_access.txt | wc -l)"
	echo " ----------------------------------------------"
	echo
	echo -e " Checked on: $(date)"
	echo
	read -p " Press Enter to continue..."
	rm -rf /var/log/nginx/check.log
	menu
}

function revokeIPTVUserID() {
	clear
	echo -e ""
	cowsay -f dragon "SELAMAT DATANG BOSKU."
	figlet -k   RKD OTT
	echo -e ""
	laneTop
	echo -e "${keatas} ${bgPutih}           REVOKE/REACTIVATE USER ID           ${plain} ${keatas}"
	laneBot
	printf " %-17s %-9s %10s\n" "USER ID" "EXP DATE" "STATUS"
	echo -e "${BlueCyan}═══════════════════════════════════════════════════${plain}";
	TODAY_IN_SECONDS=$(date +%s)
	cut -d ' ' -f2-3 /etc/kaizensystem/iptv/userlist.txt | cut -d '=' -f2-3 | sed 's/EXP_DATE=//' | sort >/etc/kaizensystem/iptv/userlist.tmp
	while IFS= read -r LINE; do
		USERNAME=$(echo $LINE | cut -d ' ' -f1)
		UUID=$(grep -w "${USERNAME}" /etc/kaizensystem/iptv/userlist.txt | sed -ne 's|UUID=\(.*\) USERNAME.*$|\1|p')
		EXP_DATE=$(echo $LINE | cut -d ' ' -f2)
		EXP_DATE_DISPLAY=$(date -d "${EXP_DATE}" +"%d-%m-%Y")
		DATE_IN_SECONDS=$(date -d "${EXP_DATE}" +%s)
		EXPIRED=$(( ${DATE_IN_SECONDS} - ${TODAY_IN_SECONDS} ))
		if [[ ${EXPIRED} -le 0 ]]; then
			if [[ $(cat /var/www/html/iptv/${UUID}.html | wc -l) -lt 20 ]]; then
				printf " %-16s ${RED}%-10s %10s${NOCOLOR}\n" "${USERNAME}" "${EXP_DATE_DISPLAY}" "revoked"
			else
				printf " %-16s ${RED}%-10s ${GREEN}%10s${NOCOLOR}\n" "${USERNAME}" "${EXP_DATE_DISPLAY}" "active"
			fi
		else
			if [[ $(cat /var/www/html/iptv/${UUID}.html | wc -l) -lt 20 ]]; then
				printf " %-16s ${GREEN}%-10s ${RED}%10s${NOCOLOR}\n" "${USERNAME}" "${EXP_DATE_DISPLAY}" "revoked"
			else
				printf " %-16s ${GREEN}%-10s %10s${NOCOLOR}\n" "${USERNAME}" "${EXP_DATE_DISPLAY}" "active"
			fi
		fi
	done </etc/kaizensystem/iptv/userlist.tmp
	echo -e "${BlueCyan}═══════════════════════════════════════════════════${plain}";
	echo -e " Total user: $(wc -l < /etc/kaizensystem/iptv/userlist.txt)"
	echo -e "${BlueCyan}═══════════════════════════════════════════════════${plain}";
	
	echo
	read -p " Select username or press c to cancel: " USERNAME
	if [[ ${USERNAME,,} = c ]]; then
		menu
	fi
	if [[ -z ${USERNAME} || $(grep -c -w "${USERNAME}" /etc/kaizensystem/iptv/userlist.txt) == 0 ]]; then
		echo -e " ${RED}Incorrect username${NOCOLOR}"
		echo
		read -p " Press Enter to try again..."
		revokeIPTVUserID
	fi
	
	UUID=$(grep -w "${USERNAME}" /etc/kaizensystem/iptv/userlist.txt | sed -ne "s|.*UUID=\(.*\) USERNAME.*$|\1|p")
	if [[ $(cat /var/www/html/iptv/${UUID}.html | wc -l) -gt 20 ]]; then
		cp -f /etc/kaizensystem/iptv/exp.html /var/www/html/iptv/${UUID}.html
		echo -e " ${GREEN}User ID has been revoked${NOCOLOR}"
		echo
		read -p " Press Enter to continue..."
		revokeIPTVUserID
	else
		echo -e " User ID has already been revoked"
		read -p " Do want to reactivate it? [y/n]: " REACTIVATE
		[[ -z ${REACTIVATE} ]] && revokeIPTVUserID
		[[ ${REACTIVATE,,} != "y" ]] && revokeIPTVUserID
		cp -f /etc/kaizensystem/iptv/kaizensystem.playlist /var/www/html/iptv/${UUID}.html
		echo -e " ${GREEN}User ID has been reactivated${NOCOLOR}"
		echo
		read -p " Press Enter to continue..."
		revokeIPTVUserID
	fi
}

# function updateIptvPlaylist() {
# 	clear
# 	echo
# 	echo -e " ${WHITE}Update Provider${NOCOLOR}"
# 	printf " %-41s %-10s\n" "PROVIDER" "URL"
# 	echo -e "${BlueCyan}═══════════════════════════════════════════════════${plain}";
# 	PROVIDER_NAME=$(sed -ne "s|IPTV=\(.*\)_http.*$|\1|p" /etc/kaizensystem/parameter)
# 	URL=$(sed -ne "s|IPTV=.*_http\(.*\)$|\1|p" /etc/kaizensystem/parameter)
# 	if [[ -z $(cat /etc/kaizensystem/iptv/providerlist.txt) ]]; then
# 		echo -e " No provider"
# 		echo
# 		read -p " Press Enter to continue..."
# 		menu
# 	else
# 		while IFS= read -r LINE; do
# 			PROVIDER_NAME=$(echo ${LINE} | awk '{print $1}')
# 			URL=$(echo ${LINE} | awk '{print $2}')
# 			printf " %-15s %-10s\n" "${PROVIDER_NAME}" "${URL}"
# 		done </etc/kaizensystem/iptv/providerlist.txt
# 	fi
# 	echo
# 	read -p " Type provider URL or press c to cancel: " URL
# 	[[ ${URL,,} == "c" ]] && menu
# 	[[ -z ${URL} ]] && updateIptvPlaylist
# 	if [[ -z $(grep -w "${URL}" /etc/kaizensystem/iptv/providerlist.txt) ]]; then
# 		echo -e " URL does not exist"
# 		echo
# 		read -p " Press Enter to continue..."
# 		updateIptvPlaylist
# 	fi
# 	read -p " Insert EPG URL (just press Enter if not sure): " EPG
# 	[[ -z ${EPG} ]] && EPG=${EPG}
# 	echo -n -e " Checking for update..."
# 	sleep 2
# 	PROVIDER_NAME=$(sed -ne "s|\(.*\) ${URL}$|\1|p" /etc/kaizensystem/iptv/providerlist.txt)
# 	OLD_PLAYLIST="/etc/kaizensystem/iptv/${PROVIDER_NAME}.playlist"
# 	rm -rf /etc/kaizensystem/iptv/${PROVIDER_NAME}.playlist.tmp
# 	curl -fsSL -o /etc/kaizensystem/iptv/${PROVIDER_NAME}.playlist.tmp "${URL}" -A "OTT Navigator/1.6.8.3 (Linux;Android 11; en; 4uborh)"
# 	NEW_PLAYLIST="/etc/kaizensystem/iptv/${PROVIDER_NAME}.playlist.tmp"
# 	if [[ ${PROVIDER_NAME,,} == "mssvpn" ]]; then
# 		TITLE=$(sed -ne 's|.*<title>\(.*\)</title>$|\1|p' ${NEW_PLAYLIST})
# 		sed -i "s/${TITLE}/Abi Darwish/" ${NEW_PLAYLIST}
# 		PROVIDERS_TELE=$(sed -ne 's|.*<meta http-equiv="refresh" content="0; URL=\(.*\)" />$|\1|p' ${NEW_PLAYLIST})
# 		MY_TELE="https://t.me/KaizenA"
# 		sed -i "s|${PROVIDERS_TELE}|${MY_TELE}|" ${NEW_PLAYLIST}
# 		MESSAGE=$(sed -ne 's|.*#EXTM3U billed-msg="\(.*\)"<script async type="text/javascript".*$|\1|p' ${NEW_PLAYLIST})
# 		sed -i "s|${MESSAGE}|${VERSIONNAME}${VERSIONNUMBER}|" ${NEW_PLAYLIST}
# 	elif [[ ${PROVIDER_NAME,,} == "ovesta123" ]]; then
# 		sed -i '/^$/d' ${NEW_PLAYLIST}
# 		sed -i '/<!DOCTYPE html/,/<noscript>/d' ${NEW_PLAYLIST}
# 		sed -i '/<\/noscript>/,/<\/html>/d' ${NEW_PLAYLIST}
# 		MESSAGE=$(sed -ne 's|.*#EXTM3U billed-msg="\(.*\)".*$|\1|p' ${NEW_PLAYLIST})
# 		sed -i "s|${MESSAGE}|${VERSIONNAME}${VERSIONNUMBER}|" ${NEW_PLAYLIST}
# 	# else
# 	# 	echo -e "\n The playlist is not supported"
# 	# 	rm -rf ${NEW_PLAYLIST}
# 	# 	echo
# 	# 	read -p " Press Enter to continue...."
# 	# 	updateIptvPlaylist
# 	fi
# 	if [[ ! -z $(diff -q ${OLD_PLAYLIST} ${NEW_PLAYLIST}) && ! -z $(grep "Warna" ${NEW_PLAYLIST}) ]]; then
# 		echo -e "\n New playlist found"
# 		read -p " Do you want to update? [y/n]: " UPDATE
# 		[[ -z ${UPDATE} || ${UPDATE,,} != "y" ]] && rm -rf ${NEW_PLAYLIST} && updateIptvPlaylist
# 		cp -f ${OLD_PLAYLIST} ${OLD_PLAYLIST}.bak
# 		DATA=$(ls -w 1 /var/www/html/iptv | sed 's/.html//')
# 		for UUID in ${DATA}; do
# 			cp -f ${NEW_PLAYLIST} /var/www/html/iptv/${UUID}.html
# 			USERNAME=$(sed -ne "s|^.*UUID=${UUID} USERNAME=\(.*\) EXP_DATE.*$|\1|p" /etc/kaizensystem/iptv/userlist.txt)
# 			printf " %-29s ${GREEN}%-10s${NOCOLOR}\n" "${USERNAME}" "updated"
# 		done
# 		mv ${NEW_PLAYLIST} ${OLD_PLAYLIST}
# 		sleep 3
# 		echo -e " Ask all users to reload their provider and EPG"
# 		echo
# 		read -p " Press Enter to continue...."
# 		updateIptvPlaylist
# 	else
# 		mv ${NEW_PLAYLIST} ${OLD_PLAYLIST}
# 		echo -e "\n ${GREEN}Your playlist is the latest one. No need to update${NOCOLOR}"
# 		echo
# 		read -p " Press Enter to continue..."
# 		updateIptvPlaylist
# 	fi
# }

function updateIptvPlaylist() {
	clear
	echo -e ""
	cowsay -f dragon "SELAMAT DATANG BOSKU."
	figlet -k   RKD OTT
	echo -e ""
	laneTop
	echo -e "${keatas} ${bgPutih}              UPDATE IPTV PLAYLIST              ${plain} ${keatas}"
	laneBot
	echo
	read -p " Are you sure to update playlist? [y/n]: " CHECK_UPDATE
	[[ ${CHECK_UPDATE,,} != "y" ]] && menu
	[[ -z ${CHECK_UPDATE} ]] && updateIptvPlaylist
	read -p " Insert EPG URL (just press Enter if not sure): " EPG
	[[ -z ${EPG} ]] && EPG=${EPG}
	DATE_DISPLAY=$(date +"%d-%m-%Y")
	NEW_PLAYLIST="/etc/kaizensystem/iptv/kaizensystem.playlist"
	sed -i '/EXTM3U billed-msg/d' ${NEW_PLAYLIST}
	sed -i "1i \#EXTM3U billed-msg=\"${VERSIONNAME}${VERSIONNUMBER}     \|     Last updated on ${DATE_DISPLAY}\"" ${NEW_PLAYLIST}
	while IFS= read -r LINE; do
		UUID=$(echo $LINE | sed -ne 's|^.*UUID=\(.*\) USERNAME.*$|\1|p')
		USERNAME=$(echo $LINE | sed -ne 's|.*USERNAME=\(.*\) EXP_DATE.*$|\1|p')
		if [[ $(cat /var/www/html/iptv/${UUID}.html | wc -l) -gt 100 ]]; then
			cp -f ${NEW_PLAYLIST} /var/www/html/iptv/${UUID}.html
			printf " %-29s ${GREEN}%-10s${NOCOLOR}\n" "${USERNAME}" "updated"
		else
			printf " %-29s ${RED}%-10s${NOCOLOR}\n" "${USERNAME}" "revoked"
		fi
	done </etc/kaizensystem/iptv/userlist.txt
	echo -e " Playlist successfully updated"
	echo
	read -p " Press Enter to continue...."
	menu
}

function updateProvider() {
	PROVIDER_NUMBER=""
	clear
	echo -e ""
	cowsay -f dragon "SELAMAT DATANG BOSKU."
	figlet -k   RKD OTT
	echo -e ""
	laneTop
	echo -e "${keatas} ${bgPutih}              UPDATE IPTV PROVIDER              ${plain} ${keatas}"
	laneBot
	echo
	if [[ $(systemctl is-active warp-svc) == "inactive" ]]; then
		echo -e " ${RED}WARP Proxy is not running. Please start it first${NOCOLOR}"
		echo
		read -p " Press Enter to continue..."
		menu
	fi
	clear
	echo -e ""
	cowsay -f dragon "SELAMAT DATANG BOSKU."
	figlet -k   RKD OTT
	echo -e ""
	laneTop
	echo -e "${keatas} ${bgPutih}              UPDATE IPTV PROVIDER              ${plain} ${keatas}"
	laneBot
	echo -e " ${WHITE}Update Provider Playlist${NOCOLOR}"
	cat /etc/kaizensystem/iptv/providerlist.txt | cut -d ' ' -f1 | nl -s '] ' -w1 | sed 's/^/ \[/'
	TOTAL_PROVIDER=$(cat /etc/kaizensystem/iptv/providerlist.txt | wc -l)
	echo
	echo -n -e " Select between [1-${TOTAL_PROVIDER}]"
	read -p " (press c to cancel): " PROVIDER_NUMBER
	[[ -z ${PROVIDER_NUMBER} ]] && updateProvider
	[[ ${PROVIDER_NUMBER,,} == "c" ]] && menu
	echo -n -e " Updating playlist..."
	PROVIDER_NAME=$(cat /etc/kaizensystem/iptv/providerlist.txt | cut -d ' ' -f1 | sed -n "${PROVIDER_NUMBER}"p)
	URL=$(grep "${PROVIDER_NAME}" /etc/kaizensystem/iptv/providerlist.txt | cut -d ' ' -f2)
	#OTT_HASH=$(grep "${PROVIDER_NAME}" /etc/kaizensystem/iptv/providerlist.txt | cut -d ' ' -f3)
	OTT_HASH=$(grep "${PROVIDER_NAME}" /etc/kaizensystem/iptv/providerlist.txt | cut -d ' ' -f3-100)
	#curl -x socks5h://127.0.0.1:40000 -sL -o /etc/kaizensystem/iptv/${PROVIDER_NAME}.playlist.tmp "${URL}" -A "OTT Navigator/1.6.8.3 (Linux;Android 11; en; ${OTT_HASH})"
	curl -x socks5h://127.0.0.1:40000 -sL -o /etc/kaizensystem/iptv/${PROVIDER_NAME}.playlist.tmp "${URL}" -A "${OTT_HASH}"
	#if [[ -z $(grep "Warna" /etc/kaizensystem/iptv/${PROVIDER_NAME}.playlist.tmp) || -z $(grep "Arena Bola" /etc/kaizensystem/iptv/${PROVIDER_NAME}.playlist.tmp) ]]; then
	#	echo
	#	echo -e " ${RED}Error while extracting ${PROVIDER_NAME} playlist${NOCOLOR}"
	#	echo
	#	read -p " Press Enter to continue..."
	#	updateProvider
	#fi
	mv /etc/kaizensystem/iptv/${PROVIDER_NAME}.playlist.tmp /etc/kaizensystem/iptv/${PROVIDER_NAME}.playlist
	cp -f /etc/kaizensystem/iptv/${PROVIDER_NAME}.playlist /var/www/html/iptv/${PROVIDER_NAME}.txt
	cp -f /etc/kaizensystem/iptv/${PROVIDER_NAME}.playlist /etc/kaizensystem/iptv/kaizensystem.playlist
	echo -n -e "${GREEN}done${NOCOLOR}"
	sleep 1
	clear
	echo
	echo -e " Download ${PROVIDER_NAME} playlist from:
 http://${DOMAIN_NAME}/iptv/${PROVIDER_NAME}.txt"
	echo
	read -p " Press Enter to continue..."
	updateProvider
}

initialCheck

function adminid() {
	switch=$(grep -i "switch" /etc/.switch | awk '{print $2}')
	clear;
	echo -e ""
	figlet -k   RKD OTT
	echo -e ""
	laneTop
	echo -e "${keatas} ${bgPutih}              SETUP BOT TELEGRAM               ${plain} ${keatas}"
	laneBot
	echo -e "$green Please follow this step.."
	echo -e " ${GREEN}[ 01 ]${NC} ► Go to @MissRose_bot and type /id to get your Admin ID"
	echo -e " ${GREEN}[ 02 ]${NC} ► Copy your Admin ID and save it"
	echo ""
	sleep 3
	read -p " Please type your Admin ID  : " ChatID
	TOKEN=6674916870:AAFKpIHIq5UTdXWzo39wq9KKgI9Pjs_j-G8
	echo "$TOKEN" > /etc/.token
	echo "$ChatID" > /etc/.chatid
	echo "switch $switch" > /etc/.switch
	sleep 1
	menubackup
}

function onoff() {
	switch=$(grep -i "switch" /etc/.switch | awk '{print $2}')
	if [ "${switch}" == "on" ]; then
		sed -i 's/switch on/switch off/g' /etc/.switch
		sed -i "/autobackup/d" /etc/crontab
		service cron restart >/dev/null 2>&1
		service cron reload >/dev/null 2>&1
		echo "Turn Off"
	else
		sed -i 's/switch off/switch on/g' /etc/.switch
		echo "1 0 * * * root autobackup" >>/etc/crontab
		service cron restart >/dev/null 2>&1
		service cron reload >/dev/null 2>&1
		echo "Turn On"
	fi
	sleep 1
	menubackup
}

function gobackup() {
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
	menubackup
}

function gorestore() {
	MYIP=$(curl -sS ipv4.icanhazip.com)
	bottoken=$(cat /etc/.token)
	adminid=$(cat /etc/.chatid)
	[[ ! -d /root/cache-restore ]] && mkdir -p /root/cache-restore
	echo -e "";
	echo -e "";
	cowsay -f dragon "SELAMAT DATANG BOSKU."
	figlet -k   RKD OTT
	echo -e ""
	laneTop
	echo -e "${keatas} ${bgPutih}               RESTORE OTT USER                ${plain} ${keatas}"
	laneBot
	echo -e "";
	read -p " Please type your File ID   : " fileId
	read -p " Please type your File PATH : " filePath
	curl -Ss --request GET \
		--url "https://api.telegram.org/file/bot${bottoken}/${filePath}?file_id=${fileId}" >/root/cache-restore/restore.zip
	sleep 1
	cd /root/cache-restore/ &>/dev/null
	unzip -o /root/cache-restore/restore.zip >/dev/null 2>&1
	rm restore.zip
	echo -e "[ ${green}INFO${NC} ] • Restore in progress..."
	sleep 1
	if [[ -f /root/cache-restore/passwd ]]; then
		passed=true
	else
		cd /root/
		rm -rf /root/cache-restore/
		clear
		echo -e "  ${ERROR} Something is wrong with your Backup Data. Please contact developer !"
		exit 1
	fi
	cp -r iptv /etc/kaizensystem &>/dev/null
	rm -rf iptv
	mv htmliptv iptv
	cp -r iptv /var/www/html  &>/dev/null
	cp -r default /etc/nginx/sites-available &>/dev/null
	cp passwd /etc/passwd &>/dev/null
	cp group /etc/group &>/dev/null
	cp shadow /etc/shadow &>/dev/null
	cp gshadow /etc/gshadow &>/dev/null
	cd /root/ &>/dev/null
	rm -rf /root/cache-restore/ &>/dev/null
	echo -e "[ ${green}INFO${NC} ] Done... "
	sleep 1
	menubackup
}

function menubackup() {
	switch=$(grep -i "switch" /etc/.switch | awk '{print $2}')
	clear
	if [ "${switch}" == "on" ]; then
		sts="\033[0;32m[On]\033[0m"
	else
		sts="\033[1;31m[Off]\033[0m"
	fi
	clear
	echo -e ""
	cowsay -f dragon "SELAMAT DATANG BOSKU."
	figlet -k   RKD OTT
	echo -e ""
	laneTop
	echo -e "${keatas} ${bgPutih}           BACKUP & RESTORE OTT USER           ${plain} ${keatas}"
	laneBot
	echo -e " $green Status AutoBackup : $sts"	
	echo -e "  ${GREEN}[ 01 ]${NC} ► Setup Admin ID";
	echo -e "  ${GREEN}[ 02 ]${NC} ► ON/OFF Auto Backup";
	echo -e "  ${GREEN}[ 03 ]${NC} ► Backup Data (Telegram Bot)";
	echo -e "  ${GREEN}[ 04 ]${NC} ► Restore Data";
	echo -e "  ${GREEN}[ 05 ]${NC} ► Back to Main Menu";
	echo -e "${CYAN}════════════════════════════════════════════${NC}";
	echo -ne "  Please enter your option [ 1 - 5 ] : "
	read botch
	case "$botch" in
	1)
		clear
		adminid
		;;
	2)
		clear
		onoff
		;;
	3)
		clear
		gobackup
		;;
	4)
		clear
		gorestore
		;;
	5)
		menu2
		;;
	*)
        echo -e "${ERROR} Wrong Option!";
        sleep 1;
        menubackup;
		;;
	esac
}

function menu2()
{
clear
echo -e ""
cowsay -f dragon "SELAMAT DATANG BOSKU."
figlet -k   RKD OTT
echo -e ""
laneTop
echo -e "${keatas} ${bgPutih}             MENU IPTV MANAGEMENT              ${plain} ${keatas}"
laneBot
echo -e "  ${green}[ 1. ]${plain} Create ID     ${green}[ 7. ]${plain} Revoke ID          "
echo -e "  ${green}[ 2. ]${plain} Verify ID     ${green}[ 8. ]${plain} Update playlist    "
echo -e "  ${green}[ 3. ]${plain} Renew ID      ${green}[ 9. ]${plain} Register Provider  "
echo -e "  ${green}[ 4. ]${plain} Delete ID     ${green}[ 10 ]${plain} Update Provider    "
echo -e "  ${green}[ 5. ]${plain} List ID       ${green}[ 11 ]${plain} Backup & Restore   "
echo -e "  ${green}[ 6. ]${plain} Check abuse   ${green}[ x. ]${plain} EXIT      		  "
echo -e ""
echo -e "${BlueCyan}═══════════════════════════════════════════════════${plain}";
echo -e ""
read -p "  Please enter your option [1-11 atau x] :  " MENU_OPTION
echo -e ""
	case ${MENU_OPTION} in
	1)
	 	createIptvUser
		;;
	2)
		verifyOTTID
		;;
	3)
		renewIPTVUser
	 	;;
	4)
	 	delIptvUser
		;;
	5)
	 	listIptvUser
		;;
	6)
	 	checkIptvAbuse
		;;
	7)
	 	revokeIPTVUserID
	 	;;
	8)
	 	updateIptvPlaylist
	 	;;
	9)
		registerProvider
		;;
	10)
		updateProvider
		;;
	11)
		menubackup
		;;
	x)
		exit 0
		;;
	*)
	menu2
esac
}
menu2