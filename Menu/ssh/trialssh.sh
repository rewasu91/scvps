	#!/bin/bash
	# ═══════════════════════════════════════════════════════════════════
	# (C) Copyright 2022 Oleh KaizenVPN
	# ═══════════════════════════════════════════════════════════════════
	# Nama        : Autoskrip VPN
	# Info        : Memasang pelbagai jenis servis vpn didalam satu skrip
	# Dibuat Pada : 30-08-2022 ( 30 Ogos 2022 )
	# OS Support  : Ubuntu & Debian
	# Owner       : KaizenVPN
	# Telegram    : https://t.me/KaizenA
	# Github      : github.com/rewasu91
	# ═══════════════════════════════════════════════════════════════════

	dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
	biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
	#########################

	# ══════════════════════════
	# // Export Warna & Maklumat
	# ══════════════════════════
	export RED='\033[1;91m';
	export GREEN='\033[1;92m';
	export YELLOW='\033[1;93m';
	export BLUE='\033[1;94m';
	export PURPLE='\033[1;95m';
	export CYAN='\033[1;96m';
	export LIGHT='\033[1;97m';
	export NC='\033[0m';

	# ════════════════════════════════
	# // Export Maklumat Status Banner
	# ════════════════════════════════
	export ERROR="[${RED} ERROR ${NC}]";
	export INFO="[${YELLOW} INFO ${NC}]";
	export OKEY="[${GREEN} OKEY ${NC}]";
	export PENDING="[${YELLOW} PENDING ${NC}]";
	export SEND="[${YELLOW} SEND ${NC}]";
	export RECEIVE="[${YELLOW} RECEIVE ${NC}]";
	export REDBG='\e[41m';
	export WBBG='\e[1;47;30m';

	# ═══════════════
	# // Export Align
	# ═══════════════
	export BOLD="\e[1m";
	export WARNING="${RED}\e[5m";
	export UNDERLINE="\e[4m";

	# ════════════════════════════
	# // Export Maklumat Sistem OS
	# ════════════════════════════
	export OS_ID=$( cat /etc/os-release | grep -w ID | sed 's/ID//g' | sed 's/=//g' | sed 's/ //g' );
	export OS_VERSION=$( cat /etc/os-release | grep -w VERSION_ID | sed 's/VERSION_ID//g' | sed 's/=//g' | sed 's/ //g' | sed 's/"//g' );
	export OS_NAME=$( cat /etc/os-release | grep -w PRETTY_NAME | sed 's/PRETTY_NAME//g' | sed 's/=//g' | sed 's/"//g' );
	export OS_KERNEL=$( uname -r );
	export OS_ARCH=$( uname -m );

	# ═══════════════════════════════════
	# // String Untuk Membantu Pemasangan
	# ═══════════════════════════════════
	export VERSION="1.0";
	export EDITION="Stable";
	export AUTHER="KaizenVPN";
	export ROOT_DIRECTORY="/etc/kaizenvpn";
	export CORE_DIRECTORY="/usr/local/kaizenvpn";
	export SERVICE_DIRECTORY="/etc/systemd/system";
	export SCRIPT_SETUP_URL="https://raw.githubusercontent.com/rewasu91/scvps/main/setup.sh";
	export REPO_URL="https://github.com/rewasu91/scvps";

	# ═══════════════
	# // Allow Access
	# ═══════════════
	BURIQ () {
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
	# https://raw.githubusercontent.com/rewasu91/scvpssettings/main/access
	MYIP=$(curl -sS ipv4.icanhazip.com)
	Name=$(curl -sS https://raw.githubusercontent.com/rewasu91/scvpssettings/main/access | grep $MYIP | awk '{print $2}')
	echo $Name > /usr/local/etc/.$Name.ini
	CekOne=$(cat /usr/local/etc/.$Name.ini)
	Bloman () {
	if [ -f "/etc/.$Name.ini" ]; then
	CekTwo=$(cat /etc/.$Name.ini)
		if [ "$CekOne" = "$CekTwo" ]; then
			res="Expired"
		fi
	else
	res="Permission Accepted..."
	fi
	}
	PERMISSION () {
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

	# ═════════════════════════════════════════════════════════
	# // Semak kalau anda sudah running sebagai root atau belum
	# ═════════════════════════════════════════════════════════
	if [[ "${EUID}" -ne 0 ]]; then
			echo -e " ${ERROR} Sila jalankan skrip ini sebagai root user";
			exit 1
	fi

	# ════════════════════════════════════════════════════════════
	# // Menyemak sistem sekiranya terdapat pemasangan yang kurang
	# ════════════════════════════════════════════════════════════
	if ! which jq > /dev/null; then
		clear;
		echo -e "${ERROR} JQ Packages Not installed";
		exit 1;
	fi

	# ═══════════════════════════════
	# // Exporting maklumat rangkaian
	# ═══════════════════════════════
	wget -qO- --inet4-only 'https://raw.githubusercontent.com/rewasu91/scvpssettings/main/get-ip_sh' | bash;
	source /root/ip-detail.txt;
	export IP_NYA="$IP";
	export ASN_NYA="$ASN";
	export ISP_NYA="$ISP";
	export REGION_NYA="$REGION";
	export CITY_NYA="$CITY";
	export COUNTRY_NYA="$COUNTRY";
	export TIME_NYA="$TIMEZONE";

	# ═════════════
	# // Clear Data
	# ═════════════
	clear;

	# ════════════════════════════════════════
	# // Membuat Akaun Percubaan SSH & OpenVPN
	# ════════════════════════════════════════
	clear;
	echo "";
	echo -e "${CYAN}════════════════════════════════════════════${NC}";
	echo -e "${WBBG} [ Membuat Akaun Percubaan SSH & OpenVPN ]  ${NC}";
	echo -e "${CYAN}════════════════════════════════════════════${NC}";
	echo -e "";
	Username="Trial-$( </dev/urandom tr -dc 0-9A-Z | head -c4 )";
	Username="$(echo ${Username} | sed 's/ //g' | tr -d '\r' | tr -d '\r\n' )"; # > // Filtering If User Type Space

	# // Validate Input
	if [[ $Username == "" ]]; then
		clear;
		echo -e "${EROR} Sila masukkan Username !";
		exit 1;
	fi

	# // Validate User Exists
	if [[ $( cat /etc/shadow | cut -d: -f1,8 | sed /:$/d | grep -w $Username ) == "" ]]; then
		Skip="true";
	else
		clear;
		echo -e "${ERROR} User ( ${YELLOW}$Username${NC} ) sudah dipakai !";
		exit 1;
	fi

	# // Trial String
	Password=123;
	Jumlah_Hari=1;

	# // String For IP & Port
	domain=$( cat /etc/kaizenvpn/domain.txt );
	openssh=$( cat /etc/ssh/sshd_config | grep -E Port | head -n1 | awk '{print $2}' );
	dropbear1=$( cat /etc/default/dropbear | grep -E DROPBEAR_PORT | sed 's/DROPBEAR_PORT//g' | sed 's/=//g' | sed 's/"//g' |  tr -d '\r' );
	dropbear2=$( cat /etc/default/dropbear | grep -E DROPBEAR_EXTRA_ARGS | sed 's/DROPBEAR_EXTRA_ARGS//g' | sed 's/=//g' | sed 's/"//g' | awk '{print $2}' |  tr -d '\r' );
	ovpn_tcp="$(netstat -nlpt | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)";
	ovpn_udp="$(netstat -nlpu | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)";
	if [[ $ovpn_tcp == "" ]]; then
		ovpn_tcp="Eror";
	fi
	if [[ $ovpn_udp == "" ]]; then
		ovpn_udp="Eror";
	fi
	stunnel_dropbear=$( cat /etc/stunnel5/stunnel5.conf | grep -i accept | head -n 4 | cut -d= -f2 | sed 's/ //g' | tr '\n' ' ' | awk '{print $2}' | tr -d '\r' );
	stunnel_ovpn_tcp=$( cat /etc/stunnel5/stunnel5.conf | grep -i accept | head -n 4 | cut -d= -f2 | sed 's/ //g' | tr '\n' ' ' | awk '{print $3}' | tr -d '\r' );
	ssh_ssl2=$( cat /lib/systemd/system/sslh.service | grep -w ExecStart | head -n1 | awk '{print $6}' | sed 's/0.0.0.0//g' | sed 's/://g' | tr '\n' ' ' | tr -d '\r' | sed 's/ //g' );
	ssh_nontls=$( cat /etc/kaizenvpn/ws-epro.conf | grep -i listen_port |  head -n 4 | cut -d= -f2 | sed 's/ //g' | sed 's/listen_port//g' | sed 's/://g' | tr '\n' ' ' | awk '{print $1}' | tr -d '\r' );
	ssh_ssl=$( cat /etc/kaizenvpn/ws-epro.conf | grep -i listen_port |  head -n 4 | cut -d= -f2 | sed 's/ //g' | sed 's/listen_port//g' | sed 's/://g' | tr '\n' ' ' | awk '{print $2}' | tr -d '\r' );
	squid1=$( cat /etc/squid/squid.conf | grep http_port | head -n 3 | cut -d= -f2 | awk '{print $2}' | sed 's/ //g' | tr '\n' ' ' | awk '{print $1}' );
	squid2=$( cat /etc/squid/squid.conf | grep http_port | head -n 3 | cut -d= -f2 | awk '{print $2}' | sed 's/ //g' | tr '\n' ' ' | awk '{print $2}' );
	ohp_1="$( cat /etc/systemd/system/ohp-mini-1.service | grep -i Port | awk '{print $3}' | head -n1)";
	ohp_2="$( cat /etc/systemd/system/ohp-mini-2.service | grep -i Port | awk '{print $3}' | head -n1)";
	ohp_3="$( cat /etc/systemd/system/ohp-mini-3.service | grep -i Port | awk '{print $3}' | head -n1)";
	ohp_4="$( cat /etc/systemd/system/ohp-mini-4.service | grep -i Port | awk '{print $3}' | head -n1)";
	udp_1=$( cat /etc/systemd/system/udp-mini-1.service | grep -i listen-addr | awk '{print $3}' | head -n1 | sed 's/127.0.0.1//g' | sed 's/://g' | tr -d '\r' );
	udp_2=$( cat /etc/systemd/system/udp-mini-2.service | grep -i listen-addr | awk '{print $3}' | head -n1 | sed 's/127.0.0.1//g' | sed 's/://g' | tr -d '\r' );
	udp_3=$( cat /etc/systemd/system/udp-mini-3.service | grep -i listen-addr | awk '{print $3}' | head -n1 | sed 's/127.0.0.1//g' | sed 's/://g' | tr -d '\r' );
	today=`date -d "0 days" +"%Y-%m-%d"`;

	# // Adding User To Server
	useradd -e `date -d "$Jumlah_Hari days" +"%Y-%m-%d"` -s /bin/false -M $Username;
	echo -e "$Password\n$Password\n"|passwd $Username &> /dev/null;
	exp=`date -d "$Jumlah_Hari days" +"%Y-%m-%d"`;

	# // Make Config Folder
	mkdir -p /etc/kaizenvpn/ssh/;
	mkdir -p /etc/kaizenvpn/ssh/${Username}/;

	# ═════════════════════════════════════════
	# // Maklumat Akaun Percubaan SSH & OpenVPN
	# ═════════════════════════════════════════
	clear; 
	echo ""; | tee -a /etc/kaizenvpn/ssh/${Username}/config.log;
	echo -e "${CYAN}════════════════════════════════════════════${NC}"; | tee -a /etc/kaizenvpn/ssh/${Username}/config.log;
	echo -e "${WBBG} [ Maklumat Akaun Percubaan SSH & OpenVPN ] ${NC}"; | tee -a /etc/kaizenvpn/ssh/${Username}/config.log;
	echo -e "${CYAN}════════════════════════════════════════════${NC}"; | tee -a /etc/kaizenvpn/ssh/${Username}/config.log;
	echo -e " Username         ► ${Username}" | tee -a /etc/kaizenvpn/ssh/${Username}/config.log;
	echo -e " Password         ► ${Password}" | tee -a /etc/kaizenvpn/ssh/${Username}/config.log;
	echo -e " Dibuat Pada      ► ${hariini}" | tee -a /etc/kaizenvpn/ssh/${Username}/config.log;
	echo -e " Expire Pada      ► $exp" | tee -a /etc/kaizenvpn/ssh/${Username}/config.log;
	echo -e "${CYAN}════════════════════════════════════════════${NC}"; | tee -a /etc/kaizenvpn/ssh/${Username}/config.log;
	echo -e " IP Address       ► ${IP_NYA}" | tee -a /etc/kaizenvpn/ssh/${Username}/config.log;
	echo -e " Domain           ► ${domain}" | tee -a /etc/kaizenvpn/ssh/${Username}/config.log;
	echo -e " OpenSSH          ► ${openssh}" | tee -a /etc/kaizenvpn/ssh/${Username}/config.log;
	echo -e " Dropbear         ► ${dropbear1},${dropbear2}" | tee -a /etc/kaizenvpn/ssh/${Username}/config.log;
	echo -e " Stunnel          ► ${ssh_ssl2},${stunnel_dropbear}" | tee -a /etc/kaizenvpn/ssh/${Username}/config.log;
	echo -e " SSH WS CDN       ► ${ssh_ssl2}" | tee -a /etc/kaizenvpn/ssh/${Username}/config.log;
	echo -e " SSH WS None TLS  ► ${ssh_nontls}" | tee -a /etc/kaizenvpn/ssh/${Username}/config.log;
	echo -e " SSH WS TLS       ► ${ssh_ssl}" | tee -a /etc/kaizenvpn/ssh/${Username}/config.log;
	echo -e " OVPN TCP         ► ${ovpn_tcp}" | tee -a /etc/kaizenvpn/ssh/${Username}/config.log;
	echo -e " OVPN UDP         ► ${ovpn_udp}" | tee -a /etc/kaizenvpn/ssh/${Username}/config.log;
	echo -e " OVPN SSL         ► ${stunnel_ovpn_tcp}" | tee -a /etc/kaizenvpn/ssh/${Username}/config.log;
	echo -e " Squid Proxy 1    ► ${squid1}" | tee -a /etc/kaizenvpn/ssh/${Username}/config.log;
	echo -e " Squid Proxy 2    ► ${squid2}" | tee -a /etc/kaizenvpn/ssh/${Username}/config.log;
	echo -e " OHP OpenSSH      ► ${ohp_1}" | tee -a /etc/kaizenvpn/ssh/${Username}/config.log;
	echo -e " OHP Dropbear     ► ${ohp_2}" | tee -a /etc/kaizenvpn/ssh/${Username}/config.log;
	echo -e " OHP OpenVPN      ► ${ohp_3}" | tee -a /etc/kaizenvpn/ssh/${Username}/config.log;
	echo -e " OHP Universal    ► ${ohp_4}" | tee -a /etc/kaizenvpn/ssh/${Username}/config.log;
	echo -e " BadVPN UDP 1     ► ${udp_1}" | tee -a /etc/kaizenvpn/ssh/${Username}/config.log;
	echo -e " BadVPN UDP 2     ► ${udp_2}" | tee -a /etc/kaizenvpn/ssh/${Username}/config.log;
	echo -e " BadVPN UDP 3     ► ${udp_3}" | tee -a /etc/kaizenvpn/ssh/${Username}/config.log;
	eecho -e "${CYAN}════════════════════════════════════════════${NC}"; | tee -a /etc/kaizenvpn/ssh/${Username}/config.log;
	echo -e " Payload WebSocket NonTLS" | tee -a /etc/kaizenvpn/ssh/${Username}/config.log;
	echo -e " GET / HTTP/1.1[crlf]Host: ${DOMAIN}[crlf]Upgrade: websocket[crlf][crlf]" | tee -a /etc/kaizenvpn/ssh/${Username}/config.log;
	echo -e "${CYAN}════════════════════════════════════════════${NC}"; | tee -a /etc/kaizenvpn/ssh/${Username}/config.log;
	echo -e " Payload WebSocket TLS" | tee -a /etc/kaizenvpn/ssh/${Username}/config.log;
	echo -e " GET wss://example.com [protocol][crlf]Host: ${DOMAIN}[crlf]Upgrade: websocket[crlf][crlf]" | tee -a /etc/kaizenvpn/ssh/${Username}/config.log;
	echo -e "${CYAN}════════════════════════════════════════════${NC}"; | tee -a /etc/kaizenvpn/ssh/${Username}/config.log;
	echo -e " Link OVPN TCP    ► http://${IP}:85/tcp.ovpn" | tee -a /etc/kaizenvpn/ssh/${Username}/config.log;
	echo -e " Link OVPN UDP    ► http://${IP}:85/udp.ovpn" | tee -a /etc/kaizenvpn/ssh/${Username}/config.log;
	echo -e " Link SSL TCP     ► http://${IP}:85/ssl-tcp.ovpn" | tee -a /etc/kaizenvpn/ssh/${Username}/config.log;
	echo -e " Link OVPN CONFIG ► http://${IP}:85/all.zip" | tee -a /etc/kaizenvpn/ssh/${Username}/config.log;
	echo -e "${CYAN}════════════════════════════════════════════${NC}"; | tee -a /etc/kaizenvpn/ssh/${Username}/config.log;
