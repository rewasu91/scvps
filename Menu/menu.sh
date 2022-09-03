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
export VERSION="2.0";
export EDITION="Multiport Edition";
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

#EXPIRED
expired=$(curl -sS https://raw.githubusercontent.com/rewasu91/scvpssettings/main/access | grep $MYIP | awk '{print $3}')
echo $expired > /root/expired.txt
today=$(date -d +1day +%Y-%m-%d)
while read expired
do
	exp=$(echo $expired | curl -sS https://raw.githubusercontent.com/rewasu91/scvpssettings/main/access | grep $MYIP | awk '{print $3}')
	if [[ $exp < $today ]]; then
		Exp2="\033[1;31mExpired\033[0m"
        else
        Exp2=$(curl -sS https://raw.githubusercontent.com/rewasu91/scvpssettings/main/access | grep $MYIP | awk '{print $3}')
	fi
done < /root/expired.txt
rm /root/expired.txt
name=$(curl -sS https://raw.githubusercontent.com/rewasu91/scvpssettings/main/access | grep $MYIP | awk '{print $2}')

domain=$(cat /etc/kaizenvpn/domain.txt)

# // Status certificate
modifyTime=$(stat $HOME/.acme.sh/${domain}_ecc/${domain}.key | sed -n '7,6p' | awk '{print $2" "$3" "$4" "$5}')
modifyTime1=$(date +%s -d "${modifyTime}")
currentTime=$(date +%s)
stampDiff=$(expr ${currentTime} - ${modifyTime1})
days=$(expr ${stampDiff} / 86400)
remainingDays=$(expr 90 - ${days})
tlsStatus=${remainingDays}
if [[ ${remainingDays} -le 0 ]]; then
	tlsStatus="expired"
fi

# // OS Uptime
uptime="$(uptime -p | cut -d " " -f 2-10)"

# //Download
# // Download/Upload today
dtoday="$(vnstat -i eth0 | grep "today" | awk '{print $2" "substr ($3, 1, 1)}')"
utoday="$(vnstat -i eth0 | grep "today" | awk '{print $5" "substr ($6, 1, 1)}')"
ttoday="$(vnstat -i eth0 | grep "today" | awk '{print $8" "substr ($9, 1, 1)}')"

# // Download/Upload yesterday
dyest="$(vnstat -i eth0 | grep "yesterday" | awk '{print $2" "substr ($3, 1, 1)}')"
uyest="$(vnstat -i eth0 | grep "yesterday" | awk '{print $5" "substr ($6, 1, 1)}')"
tyest="$(vnstat -i eth0 | grep "yesterday" | awk '{print $8" "substr ($9, 1, 1)}')"

# // Download/Upload current month
dmon="$(vnstat -i eth0 -m | grep "`date +"%Y-%m"`" | awk '{print $2" "substr ($3, 1, 1)}')"
umon="$(vnstat -i eth0 -m | grep "`date +"%Y-%m"`" | awk '{print $5" "substr ($6, 1, 1)}')"
tmon="$(vnstat -i eth0 -m | grep "`date +"%Y-%m"`" | awk '{print $8" "substr ($9, 1, 1)}')"

# // Getting CPU Information
ISP=$(curl -s ipinfo.io/org | cut -d " " -f 2-10 )
CITY=$(curl -s ipinfo.io/city )
JAM=$(date +%r)
DAY=$(date +%A)
DATE=$(date +%d.%m.%Y)
IPVPS=$(curl -s ipinfo.io/ip )

# // Ver Xray & V2ray
verxray="$(/usr/local/bin/xray -version | awk 'NR==1 {print $2}')"                                                                                                                                                                                                    

# // Bash
shellversion+=" ${BASH_VERSION/-*}" 
versibash=$shellversion

# ═════════════
# // Clear Data
# ═════════════
clear;
echo -e ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}";
echo -e "${WBBG}                   [ Maklumat Sistem ]                     ${NC}";
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}";
echo -e "  Server Uptime      ► $( uptime -p  | cut -d " " -f 2-10000 ) ";
echo -e "  Waktu Sekarang     ► $( date -d "0 days" +"%d-%m-%Y | %X" )";
echo -e "  Nama ISP           ► $ISP";
echo -e "  Operating Sistem   ► $( cat /etc/os-release | grep -w PRETTY_NAME | sed 's/PRETTY_NAME//g' | sed 's/=//g' | sed 's/"//g' )";
echo -e "  Bandar             ► $CITY";
echo -e "  Ip Vps             ► $IPVPS";
echo -e "  Domain             ► $domain";
echo -e "  Versi Xray         ► Xray-Mini 1.5.5";
echo -e "  Versi Skrip        ► V$VERSION ($EDITION)";
echo -e "  Certificate status ► Expire pada ${tlsStatus} hari";
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}";
echo -e "${WBBG}                  [ Maklumat Bandwith ]                    ${NC}";
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}";
echo -e "  ${GREEN}Traffic       Hari Ini       Kelmarin        Bulan Ini${NC}   ";
echo -e "  Download      $dtoday         $dyest          $dmon      ";
echo -e "  Upload        $utoday         $uyest          $umon      ";
echo -e "  Total         $ttoday         $tyest          $tmon      ";
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}";
echo -e "${WBBG}                      [ Menu Utama ]                       ${NC}";
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}";
echo -e "  ${GREEN}[ 01 ]${NC} ► Menu SSH & OpenVPN  ${GREEN}[ 06 ]${NC} ► Menu ShadowsocksR  ";
echo -e "  ${GREEN}[ 02 ]${NC} ► Menu Vmess          ${GREEN}[ 07 ]${NC} ► Menu Wireguard     ";
echo -e "  ${GREEN}[ 03 ]${NC} ► Menu Vless          ${GREEN}[ 08 ]${NC} ► Menu Socks 4/5     ";
echo -e "  ${GREEN}[ 04 ]${NC} ► Menu Trojan         ${GREEN}[ 09 ]${NC} ► Menu HTTP          ";
echo -e "  ${GREEN}[ 05 ]${NC} ► Menu Shadowsocks    ${GREEN}[ 10 ]${NC} ► Menu Autokill      ";
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}";
echo -e "  ${GREEN}[ 11 ]${NC} ► Speedtest";
echo -e "  ${GREEN}[ 12 ]${NC} ► Cek RAM";
echo -e "  ${GREEN}[ 13 ]${NC} ► Cek Bandwith";
echo -e "  ${GREEN}[ 14 ]${NC} ► Tukar Timezone";
echo -e "  ${GREEN}[ 15 ]${NC} ► Tukar Domain";
echo -e "  ${GREEN}[ 16 ]${NC} ► Renew Certificate";
echo -e "  ${GREEN}[ 17 ]${NC} ► Tambah Email untuk Backup";
echo -e "  ${GREEN}[ 18 ]${NC} ► Backup";
echo -e "  ${GREEN}[ 19 ]${NC} ► Restore";
echo -e "  ${GREEN}[ 20 ]${NC} ► Autobackup";
echo -e "  ${GREEN}[ 21 ]${NC} ► Tukar DNS";
echo -e "  ${GREEN}[ 22 ]${NC} ► Tukar Port";
echo -e "  ${GREEN}[ 23 ]${NC} ► Cek Maklumat Sistem & Port";
echo -e "  ${GREEN}[ 24 ]${NC} ► Cek versi skrip";
echo -e "  ${GREEN}[ 25 ]${NC} ► Reboot Server";
echo -e "  ${GREEN}[ 26 ]${NC} ► Restart Semua Servis";
echo -e "  ${GREEN}[ 27 ]${NC} ► Update Skrip";
echo -e "  ${GREEN}[ 28 ]${NC} ► Melajukan VPS (Buang log & Cache)";
echo -e "  ${GREEN}[ 29 ]${NC} ► Mengaktifkan IPV6";
echo -e "  ${GREEN}[ 30 ]${NC} ► Matikan IPV6";
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}";
echo -e "${WBBG}                   [ Maklumat Client ]                     ${NC}";
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}";
echo -e "  Nama Client       ► $name";                                                                                                                                                                              
echo -e "  Skrip Expire Pada ► $exp";    
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}";
read -p "► Sila masukkan nombor pilihan anda [1-30] : " choosemu

case $choosemu in
    1) clear && ssh-menu ;;
    2) clear && vmess-menu ;;
    3) clear && vless-menu ;;
    4) clear && trojan-menu ;;
    5) clear && ss-menu ;;
    6) clear && ssr-menu ;;
    7) clear && wg-menu ;;
    8) clear && socks-menu ;;
    9) clear && http-menu ;;
    10) clear && autokill-menu ;;
    11) clear && speedtest ;;
    12) clear && ram-usage ;;
    13) clear && vnstat ;;
    14) clear && changetime ;;
    15) clear && changedomain ;;
    16) clear && renewcert ;;
    17) clear && addemailbackup ;;
    18) clear && backup ;;
    19) clear && restore ;;
    20) clear && autobackup ;;
    21) clear && changedns ;;
    22) clear && change-port ;;
    23) clear && infonya ;;
    24) clear && vpnscript ;;
    25) clear && reboot ;;
    26) systemctl restart xray-mini@tls; systemctl restart xray-mini@nontls; systemctl restart xray-mini@socks; systemctl restart xray-mini@shadowsocks; systemctl restart xray-mini@http;
        systemctl restart nginx; systemctl restart fail2ban; systemctl restart ssr-server; systemctl restart dropbear; systemctl restart ssh; systemctl restart stunnel4; systemctl restart sslh;
        clear; echo -e "${OKEY} Selesai Restart Semua Servis !";
	clear;
    ;;
    27) cd /root/; wget -q -O /root/update.sh "https://raw.githubusercontent.com/rewasu91/scvpssettings/main/update.sh"; chmod +x /root/update.sh; ./update.sh; rm -f /root/update.sh ;;
    28)
            clear
            # // clearlog
            echo -e "${OKEY} Cleaning Your VPS Cache & Logs";
            clearlog;
            sleep 1;

            # // Restart Network
            echo -e "${OKEY} Restarting Your VPS Network";
            systemctl restart networking > /dev/null 2>&1;

            # // Hapus Logs sys
            rm -f /var/log/syslog*
            echo -e "${OKEY} Cleaning Syslogs";
            sleep 1;

            # // Hapus Logs auth di ssh
            if [ -e "/var/log/auth.log" ]; then
                    LOG="/var/log/auth.log";
            elif [ -e "/var/log/secure" ]; then
                    LOG="/var/log/secure";
            fi
            rm -f ${LOG};
            echo -e "${OKEY} Cleaning Auth logs";

            # // Start BBR
            sysctl -p > /dev/null 2>&1;
            echo -e "${OKEY} Successfull Restarting BBR Service";

            # // Done
            sleep 1;
            clear;
            echo -e "${OKEY} Selesai membuang semua log & cache server";
    ;;
    29) 
            STATUS_IPV6=$( cat /etc/sysctl.conf | grep net.ipv6.conf.all.disable_ipv6 | awk '{print $3}' | cut -d " " -f 1 | sed 's/ //g' );
            if [[ $STATUS_IPV6 == "0" ]]; then
                clear;
                echo -e "${ERROR} IPv6 sudah diaktifkan didalam server ini";
                exit 1;
            fi
            sed -i 's/net.ipv6.conf.all.disable_ipv6 = 1/net.ipv6.conf.all.disable_ipv6 = 0/g' /etc/sysctl.conf;
            sed -i 's/net.ipv6.conf.default.disable_ipv6 = 1/net.ipv6.conf.default.disable_ipv6 = 0/g' /etc/sysctl.conf;
            sed -i 's/net.ipv6.conf.lo.disable_ipv6 = 1/net.ipv6.conf.lo.disable_ipv6 = 0/g' /etc/sysctl.conf;
            sysctl -p;
            clear;
            echo -e "${OKEY} Berjaya mengaktifkan IPv6";
    ;;
    30) 
            STATUS_IPV6=$( cat /etc/sysctl.conf | grep net.ipv6.conf.all.disable_ipv6 | awk '{print $3}' | cut -d " " -f 1 | sed 's/ //g' );
            if [[ $STATUS_IPV6 == "1" ]]; then
                clear;
                echo -e "${ERROR} IPv6 sudah dihentikan didalam server ini";
                exit 1;
            fi
            sed -i 's/net.ipv6.conf.all.disable_ipv6 = 0/net.ipv6.conf.all.disable_ipv6 = 1/g' /etc/sysctl.conf;
            sed -i 's/net.ipv6.conf.default.disable_ipv6 = 0/net.ipv6.conf.default.disable_ipv6 = 1/g' /etc/sysctl.conf;
            sed -i 's/net.ipv6.conf.lo.disable_ipv6 = 0/net.ipv6.conf.lo.disable_ipv6 = 1/g' /etc/sysctl.conf;
            sysctl -p;
            clear;
            echo -e "${OKEY} Berjaya menghentikan IPv6";
    ;;
    *)
        clear;
        sleep 2
        echo -e "${ERROR} Sila masukkan nombor yang betul!";
        menu;
    ;;
esac        
