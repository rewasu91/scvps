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

function listAllIptvUser() {
	printf " %-28s %-10s\n" "USER ID" "EXP DATE"
	echo " --------------------------------------"
	TODAY_IN_SECONDS=$(date +%s)
	USER_NUMBER=$(ls -w 1 /var/www/html/iptv | wc -l)
	cut -d ' ' -f2-3 /etc/silkroad/iptv/userlist.txt | cut -d '=' -f2-3 | sed 's/EXP_DATE=//' | sort >/etc/silkroad/iptv/userlist.tmp
	if [[ ${USER_NUMBER} == 0 ]]; then
		echo " No users"
		echo
		read -p " Press Enter to continue..."
		cd
		manageMenu
	else
		while IFS= read -r LINE; do
			USERNAME=$(echo $LINE | cut -d ' ' -f1)
			EXP_DATE=$(echo $LINE | cut -d ' ' -f2)
			EXPIRED_DATE_DISPLAY=$(echo $LINE | date -d "${EXP_DATE}" +"%d-%m-%Y")
			DATE_IN_SECONDS=$(date -d "${EXP_DATE}" +%s)
			EXPIRED=$(( ${DATE_IN_SECONDS} - ${TODAY_IN_SECONDS} ))
			if [[ ${EXPIRED} -le 0 ]]; then
				EXP_USER=${USER}
				printf " %-27s ${RED}%-10s${NOCOLOR}\n" "$USERNAME" "$EXPIRED_DATE_DISPLAY"
			else
				printf " %-27s ${GREEN}%-10s${NOCOLOR}\n" "$USERNAME" "$EXPIRED_DATE_DISPLAY"
			fi
		done</etc/silkroad/iptv/userlist.tmp
	fi
	echo " --------------------------------------"
	echo -e " Total user: ${USER_NUMBER}"
	echo " --------------------------------------"
	echo
}

# function registerProvider() {
# 	URL=""
# 	PROXY_PASSWORD=""
# 	PROXY_USER=""
# 	PROXY_IP=""
# 	PROXY_PORT=""
# 	OTT_HASH=""
# 	clear
# 	header
# 	echo
# 	echo -e " ${WHITE}Register Provider${NOCOLOR}"
# 	printf " %-25s %-10s\n" "PROVIDER" "URL"
# 	echo " --------------------------------------"
# 	[[ ! -e /etc/silkroad/iptv/providerlist.txt ]] && touch /etc/silkroad/iptv/providerlist.txt
# 	if [[ -z $(cat /etc/silkroad/iptv/providerlist.txt) ]]; then
# 		echo -e " No provider"
# 		echo
# 		read -p " Press Enter to continue..."
# 		manageMenu
# 	else
# 		while IFS= read -r LINE; do
# 			PROVIDER_NAME=$(echo ${LINE} | awk '{print $1}')
# 			URL=$(echo ${LINE} | awk '{print $2}')
# 			printf " %-15s %-10s\n" "${PROVIDER_NAME}" "${URL}"
# 		done </etc/silkroad/iptv/providerlist.txt
# 	fi
# 	echo
# 	read -p " Type provider name or press c to cancel: " PROVIDER_NAME
# 	[[ ${PROVIDER_NAME,,} == "c" ]] && manageMenu
# 	[[ -z ${PROVIDER_NAME} ]] && registerProvider
# 	if [[ $(grep -c -w "${PROVIDER_NAME}" /etc/silkroad/iptv/providerlist.txt) != 0 ]]; then
# 		echo -e " Provider already registered"
# 		#read -p " Do you want to delete it? [y/n]: " DEL_PROVIDER
# 		#if [[ ${DEL_PROVIDER,,} == "y" ]]; then
# 			#echo -n -e " Deleting ${GREEN}${PROVIDER_NAME}${NOCOLOR}..."
# 			#cp -f /etc/silkroad/iptv/providerlist.txt /etc/silkroad/iptv/providerlist.txt.bak
# 			#sed -i "/^${PROVIDER_NAME}/d" /etc/silkroad/iptv/providerlist.txt
# 			#rm -rf /etc/silkroad/iptv/${PROVIDER_NAME}.playlist
# 			#sleep 2
# 			#echo -n -e "done"
# 			#sleep 1
# 			#registerProvider
# 		#else
# 			#registerProvider
# 		#fi
# 		echo
# 		read -p " Press Enter to continue..."
# 		registerProvider
# 	fi
# 	until [[ ! -z ${URL} && $(grep -c -w "${URL}" /etc/silkroad/iptv/providerlist.txt) == 0 ]]; do
# 		read -p " Type provider's URL (press c to cancel): " URL
# 		[[ ${URL,,} == "c" ]] && manageMenu
# 		echo -e " ${RED}An error occurred. Please try again...${NOCOLOR}"
# 	done
# 	clear
# 	header
# 	echo
# 	#source /etc/silkroad/parameter
# 	#if [[ ! -z ${PROXY_PASSWORD} || ! -z ${PROXY_USER} || ! -z ${PROXY_IP} || ! -z ${PROXY_PORT} ]] || ! ping -c 1 ${PROXY_IP}>/dev/null; then
# 		echo -e " To sniff a playlist, we need a proxy server"
# 		read -p " Do you want to setup a proxy server? [y/n]: " SETUP_PROXY_SERVER
# 		if [[ ${SETUP_PROXY_SERVER,,} == "y" ]]; then
# 			until [[ ! -z ${PROXY_PASSWORD} ]]; do
# 				read -p " Proxy server password: " PROXY_PASSWORD
# 			done
# 			until [[ ! -z ${PROXY_USER} ]]; do
# 				read -p " Proxy server username: " PROXY_USER
# 			done
# 			until [[ ! -z ${PROXY_IP} ]]; do
# 				read -p " Proxy server IP address: " PROXY_IP
# 			done
# 			until [[ ! -z ${PROXY_PORT} ]]; do
# 				read -p " Proxy server SSH port: " PROXY_PORT
# 			done

# 			#sed -i "/^${PROXY_PASSWORD}/d" /etc/silkroad/parameter
# 			#sed -i "/^${PROXY_USER}/d" /etc/silkroad/parameter
# 			#sed -i "/^${PROXY_IP}/d" /etc/silkroad/parameter
# 			#sed -i "/^${PROXY_PORT}/d" /etc/silkroad/parameter

# 			#echo -e "PROXY_PASSWORD=${PROXY_PASSWORD}
# #PROXY_USER=${PROXY_USER}
# #PROXY_IP=${PROXY_IP}
# #PROXY_PORT=${PROXY_PORT}">>/etc/silkroad/parameter
# 		else
# 			echo -e " Registering ${PROVIDER_NAME} is cancelled."
# 			echo
# 			read -p " Press Enter to continue..."
# 			manageMenu
# 		fi
# 	#else
# 		#echo -e " Proxy server: ${PROXY_IP}"
# 		#echo
# 		#read -p " Do you want to use this proxy server? [y/n]: " USE_FOUND_SERVER
# 		#if [[ ${USE_FOUND_SERVER,,} != "y" ]]; then
# 			#until [[ ! -z ${PROXY_PASSWORD} ]]; do
# 				#read -p " Proxy server password: " PROXY_PASSWORD
# 			#done
# 			#until [[ ! -z ${PROXY_USER} ]]; do
# 				#read -p " Proxy server username: " PROXY_USER
# 			#done
# 			#until [[ ! -z ${PROXY_IP} ]]; do
# 				#read -p " Proxy server IP address: " PROXY_IP
# 			#done
# 			#until [[ ! -z ${PROXY_PORT} ]]; do
# 				#read -p " Proxy server SSH port: " PROXY_PORT
# 			#done

# 			#sed -i "/^${PROXY_PASSWORD}/d" /etc/silkroad/parameter
# 			#sed -i "/^${PROXY_USER}/d" /etc/silkroad/parameter
# 			#sed -i "/^${PROXY_IP}/d" /etc/silkroad/parameter
# 			#sed -i "/^${PROXY_PORT}/d" /etc/silkroad/parameter

# 			#echo -e "PROXY_PASSWORD=${PROXY_PASSWORD}
# #PROXY_USER=${PROXY_USER}
# #PROXY_IP=${PROXY_IP}
# #PROXY_PORT=${PROXY_PORT}">>/etc/silkroad/parameter
# 		#fi
# 	#fi
# 	until [[ ! -z ${OTT_HASH} ]]; do
# 		read -p " OTT hash: " OTT_HASH
# 	done
# 	read -p " Type EPG URL (just press Enter if not sure): " EPG
# 	if [[ -z ${EPG} ]]; then
# 		echo -n -e " Searching internet for a reliable EPG..."
# 		EPG_URL=$(wget -q -O - http://tny.im/yourls-api.php?action=shorturl\&format=simple\&url="https://raw.githubusercontent.com/AqFad2811/epg/main/astro.xml"\&keyword=$2)
# 		EPG=$(echo ${EPG_URL})
# 		sleep 3
# 		echo -e "done"
# 	else
# 		echo -n -e " Preparing EPG..."
# 		EPG_URL=$(wget -q -O - http://tny.im/yourls-api.php?action=shorturl\&format=simple\&url="${EPG}"\&keyword=$2)
# 		EPG=$(echo ${EPG_URL})
# 		sleep 3
# 		echo -e "done"
# 	fi
# 	sshpass -p "${PROXY_PASSWORD}" ssh -o StrictHostKeyChecking=no ${PROXY_USER}@${PROXY_IP} -p ${PROXY_PORT} '[[ ! -e /var/www/html/iptv ]] && mkdir /var/www/html/iptv; [[ -z $(which nginx) ]] && apt update && apt install nginx -y; curl -fsSL -o /root/playlist.tmp "'${URL}'" -A "OTT Navigator/1.6.8.3 (Linux;Android 11; en; "'${OTT_HASH}'")"; cp -f /root/playlist.tmp /var/www/html/iptv/playlist.tmp; exit' 2>/dev/null
# 	curl -fsSL -o /etc/silkroad/iptv/${PROVIDER_NAME}.playlist.tmp http://${PROXY_IP}/iptv/playlist.tmp
# 	if [[ -z $(grep "Warna" /etc/silkroad/iptv/${PROVIDER_NAME}.playlist.tmp) || -z $(grep "Arena Bola" /etc/silkroad/iptv/${PROVIDER_NAME}.playlist.tmp) ]]; then
# 		echo -e " ${RED}Error while extracting ${PROVIDER_NAME} playlist${NOCOLOR}"
# 		echo
# 		read -p " Press Enter to continue..."
# 		registerProvider
# 	fi
# 	mv /etc/silkroad/iptv/${PROVIDER_NAME}.playlist.tmp /etc/silkroad/iptv/${PROVIDER_NAME}.playlist
# 	sed -i "/^${PROVIDER_NAME}/d" /etc/silkroad/iptv/providerlist.txt
# 	sed -i '/^$/d' /etc/silkroad/iptv/providerlist.txt
# 	echo "${PROVIDER_NAME} ${URL} ${OTT_HASH}">>/etc/silkroad/iptv/providerlist.txt
# 	sed -i '/^EPG/d' /etc/silkroad/parameter
# 	sed -i '/^$/d' /etc/silkroad/parameter
# 	echo "EPG=${EPG}">>/etc/silkroad/parameter
# 	registerProvider
# }

function registerProvider() {
	PROVIDER_ID=""
	LINK=""
	OTT_HASH=""
	clear
	header
	echo
	if [[ $(systemctl is-active warp-svc) == "inactive" ]]; then
		echo -e " $RED}WARP Proxy is not running. Please start it first${NOCOLOR}"
		echo
		read -p " Press Enter to continue..."
		manageMenu
	fi
	echo -e " ${WHITE}Register Provider${NOCOLOR}"
	printf " %-25s %-10s\n" "PROVIDER" "URL"
	echo " -----------------------------------------------"
	[[ ! -e /etc/silkroad/iptv/providerlist.txt ]] && touch /etc/silkroad/iptv/providerlist.txt
	if [[ -z $(cat /etc/silkroad/iptv/providerlist.txt) ]]; then
		echo -e " No provider"
	fi
	while IFS= read -r LINE; do
		PROVIDER_NAME=$(echo ${LINE} | awk '{print $1}')
		URL=$(echo ${LINE} | awk '{print $2}')
		printf " %-25s %-10s\n" "${PROVIDER_NAME}" "${URL}"
	done </etc/silkroad/iptv/providerlist.txt
	echo
	until [[ ! -z ${LINK} ]]; do
		read -p " Type provider's URL (press c to cancel): " LINK
		[[ ${LINK,,} == "c" ]] && manageMenu
	done
	if [[ $(grep -c -w "${LINK}" /etc/silkroad/iptv/providerlist.txt) != 0 ]]; then
		echo -e " Provider already registered"
		read -p " Do you want to delete it? [y/n]: " DEL_PROVIDER
		if [[ ${DEL_PROVIDER,,} == "y" ]]; then
			PROVIDER=$(grep -w "${LINK}" /etc/silkroad/iptv/providerlist.txt | awk '{print $1}')
			echo -n -e " Deleting ${PROVIDER}..."
			cp -f /etc/silkroad/iptv/providerlist.txt /etc/silkroad/iptv/providerlist.txt.bak
			mv /etc/silkroad/iptv/${PROVIDER}.playlist /etc/silkroad/iptv/${PROVIDER}.playlist.bak
			rm -rf /var/www/html/iptv/${PROVIDER}.txt
			sed -i "/^${PROVIDER}/d" /etc/silkroad/iptv/providerlist.txt
			sleep 2
			echo -n -e "${GREEN}done${NOCOLOR}"
			sleep 1
			registerProvider
		else
			registerProvider
		fi
	fi
	until [[ ! -z ${PROVIDER_ID} && $(grep -c -w "${PROVIDER_ID}" /etc/silkroad/iptv/providerlist.txt) == 0 ]]; do
		read -p " Type provider name (press c to cancel): " PROVIDER_ID
		[[ ${PROVIDER_ID,,} == "c" ]] && manageMenu
	done
	until [[ ! -z ${OTT_HASH} ]]; do
		#read -p " OTT hash (press c to cancel): " OTT_HASH
		read -rp " OTT hash (press c to cancel): " -e -i "\"paste within this quote\"" OTT_HASH
		[[ ${OTT_HASH,,} == "c" ]] && manageMenu
	done
	until [[ $(echo "${OTT_HASH}" | grep -c "\"") != 0 && $(echo "${OTT_HASH}" | grep -c -w "OTT") != 0 ]]; do
		echo -e " ${RED}Invalid OTT hash${NOCOLOR}"
		read -rp " OTT hash (press c to cancel): " -e -i "\"paste within this quote\"" OTT_HASH
		[[ ${OTT_HASH,,} == "c" ]] && manageMenu
	done
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
	echo -n -e " Sniffing ${PROVIDER_ID} playlist..."
	#curl -x socks5h://127.0.0.1:40000 -sL -o /etc/silkroad/iptv/${PROVIDER_ID}.playlist.tmp "${LINK}" -A "OTT Navigator/1.6.8.3 (Linux;Android 11; en; ${OTT_HASH})"
	
	curl -x socks5h://127.0.0.1:40000 -sL -o /etc/silkroad/iptv/${PROVIDER_ID}.playlist.tmp "${LINK}" -A "${OTT}"
	
	if [[ -z $(grep "Warna" /etc/silkroad/iptv/${PROVIDER_ID}.playlist.tmp) || -z $(grep "Arena Bola" /etc/silkroad/iptv/${PROVIDER_ID}.playlist.tmp) ]]; then
		echo
		echo -e " ${RED}Error while extracting ${PROVIDER_ID} playlist${NOCOLOR}"
		echo
		read -p " Press Enter to continue..."
		registerProvider
	fi
	mv /etc/silkroad/iptv/${PROVIDER_ID}.playlist.tmp /etc/silkroad/iptv/${PROVIDER_ID}.playlist
	cp -f /etc/silkroad/iptv/${PROVIDER_ID}.playlist /var/www/html/iptv/${PROVIDER_ID}.txt
	#sed -i "/^${PROVIDER_NAME}/d" /etc/silkroad/iptv/providerlist.txt
	#sed -i '/^$/d' /etc/silkroad/iptv/providerlist.txt
	echo "${PROVIDER_ID} ${LINK} ${OTT}">>/etc/silkroad/iptv/providerlist.txt
	sed -i '/^EPG/d' /etc/silkroad/parameter
	sed -i '/^$/d' /etc/silkroad/parameter
	echo "EPG=${EPG}">>/etc/silkroad/parameter
	echo -n -e "${GREEN}done${NOCOLOR}"
	sleep 1
	clear
	header
	echo
	echo -e " Download ${PROVIDER_ID} playlist from:
 https://${DOMAIN_NAME}/iptv/${PROVIDER_ID}.txt"
	echo
	read -p " Press Enter to continue..."
	registerProvider
}

function createIptvUser() {
	source /etc/silkroad/parameter
	clear
	header
	echo
	echo -e " ${WHITE}Create User${NOCOLOR}"
	printf " %-28s %-10s\n" "USER ID" "EXP DATE"
	echo " --------------------------------------"
	if [[ ! -e /etc/silkroad/iptv/providerlist.txt || -z $(cat /etc/silkroad/iptv/providerlist.txt) ]]; then
		echo -e " Please register provider first"
		echo
		read -p " Press Enter to continue..."
		manageMenu
	fi
	TODAY_IN_SECONDS=$(date +%s)
	USER_NUMBER=$(ls -w 1 /var/www/html/iptv | wc -l)
	cut -d ' ' -f2-3 /etc/silkroad/iptv/userlist.txt | cut -d '=' -f2-3 | sed 's/EXP_DATE=//' | sort >/etc/silkroad/iptv/userlist.tmp 
	if [[ ${USER_NUMBER} == 0 || ! -e /etc/silkroad/iptv/userlist.txt ]]; then
		echo " No users"
	else
		while IFS= read -r LINE; do
			USERNAME=$(echo $LINE | cut -d ' ' -f1)
			EXP_DATE=$(echo $LINE | cut -d ' ' -f2)
			EXPIRED_DATE_DISPLAY=$(echo $LINE | date -d "${EXP_DATE}" +"%d-%m-%Y")
			DATE_IN_SECONDS=$(date -d "${EXP_DATE}" +%s)
			EXPIRED=$(( ${DATE_IN_SECONDS} - ${TODAY_IN_SECONDS} ))
			if [[ ${EXPIRED} -le 0 ]]; then
				printf " %-27s ${RED}%-10s${NOCOLOR}\n" "$USERNAME" "$EXPIRED_DATE_DISPLAY"
			else
				printf " %-27s ${GREEN}%-10s${NOCOLOR}\n" "$USERNAME" "$EXPIRED_DATE_DISPLAY"
			fi
		done</etc/silkroad/iptv/userlist.tmp
		echo " --------------------------------------"
		echo -e " Total user: ${USER_NUMBER}"
		echo " --------------------------------------"
	fi
	echo
	read -p " Create username or press c to cancel: " USERNAME
	[[ ${USERNAME,,} == "c" ]] && manageMenu
	if [[ $(cat /etc/silkroad/iptv/userlist.txt | grep -c -w "${USERNAME}") != 0 ]]; then
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
	#clear
	#header
	#echo
	#echo -e " ${WHITE}List of Provider${NOCOLOR}"
	# printf " %-25s %-10s\n" "PROVIDER" "URL"
	# echo " --------------------------------------"
	#while IFS= read -r LINE; do
		#PROVIDER_NAME=$(echo ${LINE} | awk '{print $1}')
		#URL=$(echo ${LINE} | awk '{print $2}')
		# printf " %-15s %-10s\n" "${PROVIDER_NAME}" "${URL}"
		#printf " %-15s\n" "${PROVIDER_NAME}"
	#done </etc/silkroad/iptv/providerlist.txt
	#echo
	#read -p " Select provider or press c to cancel: " PROVIDER_NAME
	#[[ ${PROVIDER_NAME,,} == "c" ]] && manageMenu
	#[[ -z ${PROVIDER_NAME} ]] && createIptvUser
	#if [[ $(grep -c -w "${PROVIDER_NAME}" /etc/silkroad/iptv/providerlist.txt) == 0 ]]; then
		#echo -e " Provider not exist"
		#echo
		#read -p " Press Enter to continue..."
		#createIptvUser
	#fi
	#PLAYLIST="/etc/silkroad/iptv/${PROVIDER_NAME}.playlist"
	#PLAYLIST="/etc/silkroad/iptv/ovesta123.playlist"
	
	clear
	header
	echo
	echo -e " ${WHITE}List of Provider${NOCOLOR}"
	NUMBER_OF_PROVIDER=$(cat /etc/silkroad/iptv/providerlist.txt | cut -d ' ' -f1 | wc -l)
	
	cat /etc/silkroad/iptv/providerlist.txt | cut -d ' ' -f1 | nl -s '] ' -w1 | sed 's/^/ \[/'

	ADDITIONAL_MENU=$(( ${NUMBER_OF_PROVIDER} + 1 ))
	
	echo -e " [${ADDITIONAL_MENU}] Main menu"
	
	echo
	echo -n -e " Enter option [1-${ADDITIONAL_MENU}]"
	read -p ": " PROVIDER_NUMBER
	[[  ${PROVIDER_NUMBER} == ${ADDITIONAL_MENU} ]] && manageMenu
	echo -n -e " Sending user account details to Telegram Bot..."
	PROVIDER_NAME=$(cat /etc/silkroad/iptv/providerlist.txt | cut -d ' ' -f1 | sed -n "${PROVIDER_NUMBER}"p)

	PLAYLIST="/etc/silkroad/iptv/${PROVIDER_NAME}.playlist"

	sed -i '/EXTM3U billed-msg/d' ${PLAYLIST}
	sed -i "1i \#EXTM3U billed-msg=\"${VERSIONNAME}${VERSIONNUMBER}     \|     Last updated on ${DATE_DISPLAY}\"" ${PLAYLIST}
	cp -f ${PLAYLIST} /var/www/html/iptv/${UUID}.html
	URL="https://${DOMAIN_NAME}/iptv/${UUID}.html"
	SHORT_URL=$(wget -q -O - http://tny.im/yourls-api.php?action=shorturl\&format=simple\&url=${URL}\&keyword=$2)
	URL_SHORTENED=$(echo ${SHORT_URL})
	echo "UUID=${UUID} USERNAME=${USERNAME} EXP_DATE=${EXPIRED_DATE} URL=${URL_SHORTENED} PROVIDER_NAME=${PROVIDER_NAME}" >>/etc/silkroad/iptv/userlist.txt
	
	TEXT="<b>Silk Road v${VERSIONNUMBER}</b>
<a href=\"https://youtu.be/asRn2XMkYck\">by Abi Darwish</a>

<b>User Account Details</b>
Username%3A ${USERNAME}
Expired Date%3A ${EXPIRED_DATE_DISPLAY}

<b>OTT Navigator Playlist URL</b>
${URL_SHORTENED}

<b>EPG (Channel Info) URL</b>
${EPG}

<b>Cara Menonton IPTV</b>
1. Download aplikasi OTT Navigator di sini:
https://play.google.com/store/apps/details?id=studio.scillarium.ottnavigator%26hl=en_US

2. Ikut step seperti di dalam video ini:
https://youtu.be/asRn2XMkYck

<b>Syarat-Syarat Langganan</b>
1. Setiap URL hanya untuk satu device sahaja. Untuk device tambahan, sila langgan URL berasingan.

2. URL yang cuba dimasukkan ke dalam device selain daripada yang telah disahkan (verified), akaun anda akan disekat dan tiada refund.

Give star to the Silk Road Project <a href=\"https://github.com/abidarwish/silkroad\"><b>here</b></a>
"
	curl -s --data "parse_mode=HTML" --data "text=${TEXT}" --data "chat_id=${ID}" --request POST 'https://api.telegram.org/bot'${TOKEN}'/sendMessage' >/dev/null 2>&1

	OTT_UUID=$(xray uuid | cut -d '-' -f1)
	sed -i '/^}/d' /etc/nginx/sites-available/default
	echo -e "\n\tlocation = /iptv/${UUID}.html {
\t\tif (\$http_user_agent != \"OTT Navigator/1.6.8.3 (Linux;Android 11; en; ${OTT_UUID})\") { # UUID=${UUID}
\t\t\trewrite ^ http://tny.im/oQXIQ last;
\t\t}
\t}
}">>/etc/nginx/sites-available/default
	echo -n -e "${GREEN}done${NOCOLOR}"
	#systemctl restart nginx
	nginx -s reload
	createIptvUser
}

function verifyOTTID() {
	clear
	header
	echo
	echo -e " ${WHITE}Verify User${NOCOLOR}"
	cut -d ' ' -f2 /etc/silkroad/iptv/userlist.txt | cut -d '=' -f2 | sort >/etc/silkroad/iptv/userlist.tmp 
	if [[ -z $(cat /etc/silkroad/iptv/userlist.txt) ]]; then
		echo -e " No user"
		echo
		read -p " Press Enter to continue..."
		manageMenu
	else
		while IFS= read -r LINE; do
			USERNAME=$(echo $LINE | awk '{print $1}')
			UUID=$(grep -w "${USERNAME}" /etc/silkroad/iptv/userlist.txt | sed -ne 's|^UUID=\(.*\) USERNAME.*$|\1|p')
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
		done</etc/silkroad/iptv/userlist.tmp
	fi
	echo " --------------------------------------"
	echo
	read -p " Select username or press c to cancel: " USERNAME
	[[ -z ${USERNAME} ]] && verifyOTTID
	[[ ${USERNAME,,} == "c" ]] && manageMenu
	if [[ $(grep -w -c "USERNAME=${USERNAME}" /etc/silkroad/iptv/userlist.txt) == 0 ]]; then
		echo -e " ${USERNAME} does no exist"
		echo
		read -p " Press Enter to try again..."
		verifyOTTID
	fi
	UUID=$(grep -w "${USERNAME}" /etc/silkroad/iptv/userlist.txt | sed -ne "s|.*UUID=\(.*\) USERNAME.*$|\1|p")
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
	header
	echo
	echo -e " ${WHITE}Renew User ID${NOCOLOR}"
	listAllIptvUser
	read -p " Select username or press c to cancel: " USERNAME
	if [[ ${USERNAME,,} = "c" ]]; then
		manageMenu
	fi
	if [[ -z $USERNAME || $(grep -c -w "${USERNAME}" /etc/silkroad/iptv/userlist.txt) == 0 ]]; then
		echo -e " ${RED}Incorrect username${NOCOLOR}"
		echo
		read -p " Press Enter to try again..."
		renewIPTVUser
	fi

	read -p " Expired (days): " ACTIVE
	[[ -z ${ACTIVE} ]] && ACTIVE=1

	OLD_EXPIRED_DATE=$(sed -ne "s|.*USERNAME=${USERNAME} EXP_DATE=\(.*\) URL.*$|\1|p" /etc/silkroad/iptv/userlist.txt)
	NEW_EXPIRED_DATE=$(date -d "${ACTIVE} days" +"%Y-%m-%d")
	EXPIRED_DATE_DISPLAY=$(date -d "$NEW_EXPIRED_DATE" +"%d-%m-%Y")
	UUID=$(sed -ne "s|.*UUID=\(.*\) USERNAME=${USERNAME} EXP_DATE.*$|\1|p" /etc/silkroad/iptv/userlist.txt)
	URL=$(sed -ne "s|.*${USERNAME} EXP_DATE.* URL=\(.*\) PROVIDER_NAME.*$|\1|p" /etc/silkroad/iptv/userlist.txt)

	sed -i "s|UUID=${UUID} USERNAME=${USERNAME} EXP_DATE=${OLD_EXPIRED_DATE}|UUID=${UUID} USERNAME=${USERNAME} EXP_DATE=${NEW_EXPIRED_DATE}|" /etc/silkroad/iptv/userlist.txt 
	sed -E -i "s|^#UUID=${UUID} USERNAME=${USERNAME} EXP_DATE=${OLD_EXPIRED_DATE}|UUID=${UUID} USERNAME=${USERNAME} EXP_DATE=${NEW_EXPIRED_DATE}|" /etc/silkroad/iptv/userlist.txt
	
	cp -f /etc/silkroad/iptv/silkroad.playlist /var/www/html/iptv/${UUID}.html

	clear
	header
	echo
	echo -e " ${WHITE}User Account Details${NOCOLOR}
 Username: $USERNAME
 Expired date: $EXPIRED_DATE_DISPLAY
 OTT Nav URL: ${URL}"
	echo
	read -p " Press Enter to continue..."
	renewIPTVUser
}

function delIptvUser() {
	clear
	header
	echo
	echo -e " ${WHITE}Delete User ID${NOCOLOR}"
	listAllIptvUser
	read -p " Select username or press c to cancel: " USERNAME
	if [[ ${USERNAME,,} = c ]]; then
		manageMenu
	fi
	if [[ -z ${USERNAME} || $(grep -c -w "${USERNAME}" /etc/silkroad/iptv/userlist.txt) == 0 ]]; then
		echo -e " ${RED}Incorrect username${NOCOLOR}"
		echo
		read -p " Press Enter to try again..."
		delIptvUser
	fi
	
	UUID=$(grep -w "${USERNAME}" /etc/silkroad/iptv/userlist.txt | sed -ne "s|.*UUID=\(.*\) USERNAME.*$|\1|p")
	
	sed -i "/UUID=${UUID} USERNAME=${USERNAME}/d" /etc/silkroad/iptv/userlist.txt
	sed -i "/^#UUID=${UUID} USERNAME=${USERNAME}/d" /etc/silkroad/iptv/userlist.txt

	sed -i "/\/iptv\/${UUID}.html/,/^\t}/d" /etc/nginx/sites-available/default
	
	sed -i '/^$/d' /etc/nginx/sites-available/default

	rm -rf /var/www/html/iptv/${UUID}.html

	echo -e " ${GREEN}ID has been deleted${NOCOLOR}"
    echo
	read -p " Press Enter to continue..."
	#systemctl restart nginx
	nginx -s reload
	delIptvUser
}

function listIptvUser() {
	source /etc/silkroad/parameter
	clear
	header
	echo
	echo -e " ${WHITE}List User ID${NOCOLOR}"
	printf " %-28s %-10s\n" "USER ID" "EXP DATE"
	echo " --------------------------------------"
	TODAY_IN_SECONDS=$(date +%s)
	USER_NUMBER=$(ls -w 1 /var/www/html/iptv | wc -l)
	cut -d ' ' -f2-3 /etc/silkroad/iptv/userlist.txt | cut -d '=' -f2-3 | sed 's/EXP_DATE=//' | sort >/etc/silkroad/iptv/userlist.tmp
	if [[ ${USER_NUMBER} == 0 ]]; then
		echo " No users"
		echo
		read -p " Press Enter to continue..."
		cd
		manageMenu
	else
		while IFS= read -r LINE; do
			USERNAME=$(echo $LINE | cut -d ' ' -f1)
			EXP_DATE=$(echo $LINE | cut -d ' ' -f2)
			EXPIRED_DATE_DISPLAY=$(echo $LINE | date -d "${EXP_DATE}" +"%d-%m-%Y")
			DATE_IN_SECONDS=$(date -d "${EXP_DATE}" +%s)
			EXPIRED=$(( ${DATE_IN_SECONDS} - ${TODAY_IN_SECONDS} ))
			if [[ ${EXPIRED} -le 0 ]]; then
				EXP_USER=${USER}
				printf " %-27s ${RED}%-10s${NOCOLOR}\n" "$USERNAME" "$EXPIRED_DATE_DISPLAY"
			else
				printf " %-27s ${GREEN}%-10s${NOCOLOR}\n" "$USERNAME" "$EXPIRED_DATE_DISPLAY"
			fi
		done</etc/silkroad/iptv/userlist.tmp
	fi
	echo " --------------------------------------"
	echo -e " Total user: ${USER_NUMBER}"
	echo " --------------------------------------"
	echo
	read -p " Select username or press c to cancel: " USERNAME
	[[ ${USERNAME,,} = c ]] && manageMenu
	if [[ -z ${USERNAME} || $(grep -c -w "${USERNAME}" /etc/silkroad/iptv/userlist.txt) == 0 ]]; then
		echo -e " ${RED}Incorrect username${NOCOLOR}"
		echo
		read -p " Press Enter to try again..."
		delIptvUser
	fi
	
	UUID=$(sed -ne "s|.*UUID=\(.*\) USERNAME=${USERNAME} EXP_DATE.*$|\1|p" /etc/silkroad/iptv/userlist.txt)
	EXP_DATE=$(sed -ne "s|.*USERNAME=${USERNAME} EXP_DATE=\(.*\) URL.*$|\1|p" /etc/silkroad/iptv/userlist.txt)
	EXPIRED_DATE_DISPLAY=$(date -d "${EXP_DATE}" +"%d-%m-%Y")
	
	URL=$(sed -ne "s|.*${UUID}.* URL=\(.*\) PROVIDER_NAME.*$|\1|p" /etc/silkroad/iptv/userlist.txt)

	clear
	header
	echo
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
	header
	echo
	echo -e " ${WHITE}Check Abuse${NOCOLOR}"
	printf " %-17s %-21s %5s\n" "USER" "DEVICE" "STATUS"
	echo " ----------------------------------------------"
	cat /var/log/nginx/access.log.1 >/var/log/nginx/check.log
	cat /var/log/nginx/access.log >>/var/log/nginx/check.log
	sed -ne 's|.*iptv/\(.*\).html.*; \(.*\))"$|\1 \2|p' /var/log/nginx/check.log | sed '/unverified/d' | sed '/^exp/d' | sort | uniq >/etc/silkroad/iptv/user_access.txt
	if [[ $(cat /etc/silkroad/iptv/user_access.txt | sed '/^$/d' | wc -l) == 0 ]]; then
		echo
		echo -e " No online users"
		echo
		echo " ----------------------------------------------"
		echo -e " Total device: 0"
		echo " ----------------------------------------------"
		echo
		read -p " Press Enter to continue..."
		manageMenu
	fi
	while IFR= read -r LINE; do
		FILE_ID=$(echo ${LINE} | cut -d' ' -f1)
		USERNAME=$(grep -w "${FILE_ID}" /etc/silkroad/iptv/userlist.txt | sed -ne "s|.*USERNAME=\(.*\) EXP_DATE.*$|\1|p")
		DEVICE_ID=$(echo ${LINE} | cut -d' ' -f2)
		if [[ $(grep -c -w "${FILE_ID}" /etc/silkroad/iptv/user_access.txt) > 1 ]]; then
			printf " %-17s %-21s ${RED}%-10s${NOCOLOR}\n" "${USERNAME}" "${DEVICE_ID}" "alert"
		else
			printf " %-17s %-21s ${GREEN}%-10s${NOCOLOR}\n" "${USERNAME}" "${DEVICE_ID}" "online"
		fi
	done</etc/silkroad/iptv/user_access.txt
	echo " ----------------------------------------------"
	echo -e " Total device: $(cat /etc/silkroad/iptv/user_access.txt | wc -l)"
	echo " ----------------------------------------------"
	echo
	echo -e " Checked on: $(date)"
	echo
	read -p " Press Enter to continue..."
	rm -rf /var/log/nginx/check.log
	manageMenu
}

function revokeIPTVUserID() {
	clear
	header
	echo
	echo -e " ${WHITE}Revoke User ID${NOCOLOR}"
	printf " %-17s %-9s %10s\n" "USER ID" "EXP DATE" "STATUS"
	echo " --------------------------------------"
	TODAY_IN_SECONDS=$(date +%s)
	cut -d ' ' -f2-3 /etc/silkroad/iptv/userlist.txt | cut -d '=' -f2-3 | sed 's/EXP_DATE=//' | sort >/etc/silkroad/iptv/userlist.tmp
	while IFS= read -r LINE; do
		USERNAME=$(echo $LINE | cut -d ' ' -f1)
		UUID=$(grep -w "${USERNAME}" /etc/silkroad/iptv/userlist.txt | sed -ne 's|UUID=\(.*\) USERNAME.*$|\1|p')
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
	done</etc/silkroad/iptv/userlist.tmp
	echo " --------------------------------------"
	echo -e " Total user: $(ls /var/www/html/iptv/ | sed '/exp/d' | wc -l)"
	echo " --------------------------------------"
	echo
	read -p " Select username or press c to cancel: " USERNAME
	if [[ ${USERNAME,,} = c ]]; then
		manageMenu
	fi
	if [[ -z ${USERNAME} || $(grep -c -w "${USERNAME}" /etc/silkroad/iptv/userlist.txt) == 0 ]]; then
		echo -e " ${RED}Incorrect username${NOCOLOR}"
		echo
		read -p " Press Enter to try again..."
		revokeIPTVUserID
	fi
	
	UUID=$(grep -w "${USERNAME}" /etc/silkroad/iptv/userlist.txt | sed -ne "s|.*UUID=\(.*\) USERNAME.*$|\1|p")
	if [[ $(cat /var/www/html/iptv/${UUID}.html | wc -l) -gt 20 ]]; then
		cp -f /etc/silkroad/iptv/exp.html /var/www/html/iptv/${UUID}.html
		echo -e " ${GREEN}User ID has been revoked${NOCOLOR}"
		echo
		read -p " Press Enter to continue..."
		revokeIPTVUserID
	else
		echo -e " User ID has already been revoked"
		read -p " Do want to reactivate it? [y/n]: " REACTIVATE
		[[ -z ${REACTIVATE} ]] && revokeIPTVUserID
		[[ ${REACTIVATE,,} != "y" ]] && revokeIPTVUserID
		cp -f /etc/silkroad/iptv/silkroad.playlist /var/www/html/iptv/${UUID}.html
		echo -e " ${GREEN}User ID has been reactivated${NOCOLOR}"
		echo
		read -p " Press Enter to continue..."
		revokeIPTVUserID
	fi
}

# function updateIptvPlaylist() {
# 	clear
# 	header
# 	echo
# 	echo -e " ${WHITE}Update Provider${NOCOLOR}"
# 	printf " %-25s %-10s\n" "PROVIDER" "URL"
# 	echo " --------------------------------------"
# 	PROVIDER_NAME=$(sed -ne "s|IPTV=\(.*\)_http.*$|\1|p" /etc/silkroad/parameter)
# 	URL=$(sed -ne "s|IPTV=.*_http\(.*\)$|\1|p" /etc/silkroad/parameter)
# 	if [[ -z $(cat /etc/silkroad/iptv/providerlist.txt) ]]; then
# 		echo -e " No provider"
# 		echo
# 		read -p " Press Enter to continue..."
# 		manageMenu
# 	else
# 		while IFS= read -r LINE; do
# 			PROVIDER_NAME=$(echo ${LINE} | awk '{print $1}')
# 			URL=$(echo ${LINE} | awk '{print $2}')
# 			printf " %-15s %-10s\n" "${PROVIDER_NAME}" "${URL}"
# 		done </etc/silkroad/iptv/providerlist.txt
# 	fi
# 	echo
# 	read -p " Type provider URL or press c to cancel: " URL
# 	[[ ${URL,,} == "c" ]] && manageMenu
# 	[[ -z ${URL} ]] && updateIptvPlaylist
# 	if [[ -z $(grep -w "${URL}" /etc/silkroad/iptv/providerlist.txt) ]]; then
# 		echo -e " URL does not exist"
# 		echo
# 		read -p " Press Enter to continue..."
# 		updateIptvPlaylist
# 	fi
# 	read -p " Insert EPG URL (just press Enter if not sure): " EPG
# 	[[ -z ${EPG} ]] && EPG=${EPG}
# 	echo -n -e " Checking for update..."
# 	sleep 2
# 	PROVIDER_NAME=$(sed -ne "s|\(.*\) ${URL}$|\1|p" /etc/silkroad/iptv/providerlist.txt)
# 	OLD_PLAYLIST="/etc/silkroad/iptv/${PROVIDER_NAME}.playlist"
# 	rm -rf /etc/silkroad/iptv/${PROVIDER_NAME}.playlist.tmp
# 	curl -fsSL -o /etc/silkroad/iptv/${PROVIDER_NAME}.playlist.tmp "${URL}" -A "OTT Navigator/1.6.8.3 (Linux;Android 11; en; 4uborh)"
# 	NEW_PLAYLIST="/etc/silkroad/iptv/${PROVIDER_NAME}.playlist.tmp"
# 	if [[ ${PROVIDER_NAME,,} == "mssvpn" ]]; then
# 		TITLE=$(sed -ne 's|.*<title>\(.*\)</title>$|\1|p' ${NEW_PLAYLIST})
# 		sed -i "s/${TITLE}/Abi Darwish/" ${NEW_PLAYLIST}
# 		PROVIDERS_TELE=$(sed -ne 's|.*<meta http-equiv="refresh" content="0; URL=\(.*\)" />$|\1|p' ${NEW_PLAYLIST})
# 		MY_TELE="https://t.me/abidarwish"
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
# 			USERNAME=$(sed -ne "s|^.*UUID=${UUID} USERNAME=\(.*\) EXP_DATE.*$|\1|p" /etc/silkroad/iptv/userlist.txt)
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
	header
	echo
	read -p " Are you sure to update playlist? [y/n]: " CHECK_UPDATE
	[[ ${CHECK_UPDATE,,} != "y" ]] && manageMenu
	[[ -z ${CHECK_UPDATE} ]] && updateIptvPlaylist
	read -p " Insert EPG URL (just press Enter if not sure): " EPG
	[[ -z ${EPG} ]] && EPG=${EPG}
	DATE_DISPLAY=$(date +"%d-%m-%Y")
	NEW_PLAYLIST="/etc/silkroad/iptv/silkroad.playlist"
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
	done</etc/silkroad/iptv/userlist.txt
	echo -e " Playlist successfully updated"
	echo
	read -p " Press Enter to continue...."
	manageMenu
}

function updateProvider() {
	PROVIDER_NUMBER=""
	clear
	header
	echo
	if [[ $(systemctl is-active warp-svc) == "inactive" ]]; then
		echo -e " ${RED}WARP Proxy is not running. Please start it first${NOCOLOR}"
		echo
		read -p " Press Enter to continue..."
		manageMenu
	fi
	echo -e " ${WHITE}Update Provider Playlist${NOCOLOR}"
	cat /etc/silkroad/iptv/providerlist.txt | cut -d ' ' -f1 | nl -s '] ' -w1 | sed 's/^/ \[/'
	TOTAL_PROVIDER=$(cat /etc/silkroad/iptv/providerlist.txt | wc -l)
	echo
	echo -n -e " Select between [1-${TOTAL_PROVIDER}]"
	read -p " (press c to cancel): " PROVIDER_NUMBER
	[[ -z ${PROVIDER_NUMBER} ]] && updateProvider
	[[ ${PROVIDER_NUMBER,,} == "c" ]] && manageMenu
	echo -n -e " Updating playlist..."
	PROVIDER_NAME=$(cat /etc/silkroad/iptv/providerlist.txt | cut -d ' ' -f1 | sed -n "${PROVIDER_NUMBER}"p)
	URL=$(grep "${PROVIDER_NAME}" /etc/silkroad/iptv/providerlist.txt | cut -d ' ' -f2)
	#OTT_HASH=$(grep "${PROVIDER_NAME}" /etc/silkroad/iptv/providerlist.txt | cut -d ' ' -f3)
	OTT_HASH=$(grep "${PROVIDER_NAME}" /etc/silkroad/iptv/providerlist.txt | cut -d ' ' -f3-100)
	#curl -x socks5h://127.0.0.1:40000 -sL -o /etc/silkroad/iptv/${PROVIDER_NAME}.playlist.tmp "${URL}" -A "OTT Navigator/1.6.8.3 (Linux;Android 11; en; ${OTT_HASH})"
	curl -x socks5h://127.0.0.1:40000 -sL -o /etc/silkroad/iptv/${PROVIDER_NAME}.playlist.tmp "${URL}" -A "${OTT_HASH}"
	if [[ -z $(grep "Warna" /etc/silkroad/iptv/${PROVIDER_NAME}.playlist.tmp) || -z $(grep "Arena Bola" /etc/silkroad/iptv/${PROVIDER_NAME}.playlist.tmp) ]]; then
		echo
		echo -e " ${RED}Error while extracting ${PROVIDER_NAME} playlist${NOCOLOR}"
		echo
		read -p " Press Enter to continue..."
		updateProvider
	fi
	mv /etc/silkroad/iptv/${PROVIDER_NAME}.playlist.tmp /etc/silkroad/iptv/${PROVIDER_NAME}.playlist
	cp -f /etc/silkroad/iptv/${PROVIDER_NAME}.playlist /var/www/html/iptv/${PROVIDER_NAME}.txt
	echo -n -e "${GREEN}done${NOCOLOR}"
	sleep 1
	clear
	header
	echo
	echo -e " Download ${PROVIDER_NAME} playlist from:
 https://${DOMAIN_NAME}/iptv/${PROVIDER_NAME}.txt"
	echo
	read -p " Press Enter to continue..."
	updateProvider
}

initialCheck

clear
ln -s /usr/games/cowsay /bin
ln -s /usr/games/fortune /bin
echo -e ""
cowsay -f dragon "SELAMAT DATANG BOSKU."
figlet -k IPTV_OTT
echo -e ""
laneTop
echo -e "${keatas} ${bgPutih}             MENU IPTV MANAGEMENT              ${plain} ${keatas}"
laneBot
echo -e "  ${green}[ 1. ]${plain} Create ID     ${green}[ 6. ]${plain} Check abuse        "
echo -e "  ${green}[ 2. ]${plain} Verify ID     ${green}[ 7. ]${plain} Update playlist    "
echo -e "  ${green}[ 3. ]${plain} Renew ID      ${green}[ 8. ]${plain} Update playlist    "
echo -e "  ${green}[ 4. ]${plain} Delete ID     ${green}[ 9. ]${plain} Register Provider  "
echo -e "  ${green}[ 5. ]${plain} List ID       ${green}[ 10 ]${plain} Update Provider    "
echo -e ""
echo -e "${BlueCyan}═══════════════════════════════════════════════════${plain}";
echo -e ""
read -p "  Sila masukkan nombor pilihan anda [1-10 atau x] :  " MENU_OPTION
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
		exit 0
		;;
	*)
	menu
	esac
