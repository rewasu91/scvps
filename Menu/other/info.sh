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

# ═════════════
# // Clear Data
# ═════════════
clear;

waktu_sekarang=$(date -d "0 days" +"%Y-%m-%d");
#expired_date="$EXPIRED";
now_in_s=$(date -d "$waktu_sekarang" +%s);
exp_in_s=$(date -d "$expired_date" +%s);
days_left=$(( ($exp_in_s - $now_in_s) / 86400 ));

# // Code for service
if [[ $(systemctl status nginx | grep Active | awk '{print $2}' | sed 's/(//g' | sed 's/)//g' | sed 's/ //g') == "active" ]]; then
    NGINX_STT="${GREEN}Running${NC}";
else
    NGINX_STT="${RED}Not Running${NC}";
fi
if [[ $(systemctl status stunnel4 | grep Active | awk '{print $2}' | sed 's/(//g' | sed 's/)//g' | sed 's/ //g') == "active" ]]; then
    STUNNEL4_STT="${GREEN}Running${NC}";
else
    STUNNEL4_STT="${RED}Not Running${NC}";
fi
if [[ $(systemctl status ssh | grep Active | awk '{print $2}' | sed 's/(//g' | sed 's/)//g' | sed 's/ //g') == "active" ]]; then
    SSH_STT="${GREEN}Running${NC}";
else
    SSH_STT="${RED}Not Running${NC}";
fi
if [[ $(systemctl status dropbear | grep Active | awk '{print $2}' | sed 's/(//g' | sed 's/)//g' | sed 's/ //g') == "active" ]]; then
    DROPBEAR_STT="${GREEN}Running${NC}";
else
    DROPBEAR_STT="${RED}Not Running${NC}";
fi
if [[ $(systemctl status ws-epro | grep Active | awk '{print $2}' | sed 's/(//g' | sed 's/)//g' | sed 's/ //g') == "active" ]]; then
    WSEPRO_STT="${GREEN}Running${NC}";
else
    WSEPRO_STT="${RED}Not Running${NC}";
fi
if [[ $(systemctl status ohp-mini-1 | grep Active | awk '{print $2}' | sed 's/(//g' | sed 's/)//g' | sed 's/ //g') == "active" ]]; then
    OHP_1="${GREEN}Running${NC}";
else
    OHP_1="${RED}Not Running${NC}";
fi
if [[ $(systemctl status ohp-mini-2 | grep Active | awk '{print $2}' | sed 's/(//g' | sed 's/)//g' | sed 's/ //g') == "active" ]]; then
    OHP_2="${GREEN}Running${NC}";
else
    OHP_2="${RED}Not Running${NC}";
fi
if [[ $(systemctl status ohp-mini-3 | grep Active | awk '{print $2}' | sed 's/(//g' | sed 's/)//g' | sed 's/ //g') == "active" ]]; then
    OHP_3="${GREEN}Running${NC}";
else
    OHP_3="${RED}Not Running${NC}";
fi
if [[ $(systemctl status ohp-mini-4 | grep Active | awk '{print $2}' | sed 's/(//g' | sed 's/)//g' | sed 's/ //g') == "active" ]]; then
    OHP_4="${GREEN}Running${NC}";
else
    OHP_4="${RED}Not Running${NC}";
fi
if [[ $(systemctl status ohp-mini-4 | grep Active | awk '{print $2}' | sed 's/(//g' | sed 's/)//g' | sed 's/ //g') == "active" ]]; then
    OHP_4="${GREEN}Running${NC}";
else
    OHP_4="${RED}Not Running${NC}";
fi
if [[ $(systemctl status squid | grep Active | awk '{print $2}' | sed 's/(//g' | sed 's/)//g' | sed 's/ //g') == "active" ]]; then
    SQUID_STT="${GREEN}Running${NC}";
else
    SQUID_STT="${RED}Not Running${NC}";
fi
if [[ $(systemctl status sslh | grep Active | awk '{print $2}' | sed 's/(//g' | sed 's/)//g' | sed 's/ //g') == "active" ]]; then
    SSLH_STT="${GREEN}Running${NC}";
else
    SSLH_STT="${RED}Not Running${NC}";
fi
if [[ $(systemctl status sslh | grep Active | awk '{print $2}' | sed 's/(//g' | sed 's/)//g' | sed 's/ //g') == "active" ]]; then
    SSLH_STT="${GREEN}Running${NC}";
else
    SSLH_STT="${RED}Not Running${NC}";
fi
if [[ $(systemctl status xray-mini@tls | grep Active | awk '{print $2}' | sed 's/(//g' | sed 's/)//g' | sed 's/ //g') == "active" ]]; then
    XRAY_TCP="${GREEN}Running${NC}";
else
    XRAY_TCP="${RED}Not Running${NC}";
fi
if [[ $(systemctl status xray-mini@nontls | grep Active | awk '{print $2}' | sed 's/(//g' | sed 's/)//g' | sed 's/ //g') == "active" ]]; then
    XRAY_NTLS="${GREEN}Running${NC}";
else
    XRAY_NTLS="${RED}Not Running${NC}";
fi
if [[ $(systemctl status xray-mini@shadowsocks | grep Active | awk '{print $2}' | sed 's/(//g' | sed 's/)//g' | sed 's/ //g') == "active" ]]; then
    SS_UDP="${GREEN}Running${NC}";
else
    SS_UDP="${RED}Not Running${NC}";
fi
if [[ $(systemctl status xray-mini@socks | grep Active | awk '{print $2}' | sed 's/(//g' | sed 's/)//g' | sed 's/ //g') == "active" ]]; then
    SOCKS_STT="${GREEN}Running${NC}";
else
    SOCKS_STT="${RED}Not Running${NC}";
fi
if [[ $(systemctl status xray-mini@http | grep Active | awk '{print $2}' | sed 's/(//g' | sed 's/)//g' | sed 's/ //g') == "active" ]]; then
    HTTP_STT="${GREEN}Running${NC}";
else
    HTTP_STT="${RED}Not Running${NC}";
fi
if [[ $(systemctl status xray-mini@http | grep Active | awk '{print $2}' | sed 's/(//g' | sed 's/)//g' | sed 's/ //g') == "active" ]]; then
    HTTP_STT="${GREEN}Running${NC}";
else
    HTTP_STT="${RED}Not Running${NC}";
fi
if [[ $(systemctl status ssr-server | grep Active | awk '{print $2}' | sed 's/(//g' | sed 's/)//g' | sed 's/ //g') == "active" ]]; then
    SSR_UDP="${GREEN}Running${NC}";
else
    SSR_UDP="${RED}Not Running${NC}";
fi
if [[ $(systemctl status wg-quick@wg0 | grep Active | awk '{print $2}' | sed 's/(//g' | sed 's/)//g' | sed 's/ //g') == "active" ]]; then
    WG_STT="${GREEN}Running${NC}";
else
    WG_STT="${RED}Not Running${NC}";
fi
if [[ $(systemctl status openvpn@tcp | grep Active | awk '{print $2}' | sed 's/(//g' | sed 's/)//g' | sed 's/ //g') == "active" ]]; then
    OVPN_TCP="${GREEN}Running${NC}";
else
    OVPN_TCP="${RED}Not Running${NC}";
fi
if [[ $(systemctl status openvpn@udp | grep Active | awk '{print $2}' | sed 's/(//g' | sed 's/)//g' | sed 's/ //g') == "active" ]]; then
    OVPN_UDP="${GREEN}Running${NC}";
else
    OVPN_UDP="${RED}Not Running${NC}";
fi
if [[ $(systemctl status vmess-kill | grep Active | awk '{print $2}' | sed 's/(//g' | sed 's/)//g' | sed 's/ //g') == "active" ]]; then
    VMESS_KILL="${GREEN}Running${NC}";
else
    VMESS_KILL="${RED}Not Running${NC}";
fi
if [[ $(systemctl status vless-kill | grep Active | awk '{print $2}' | sed 's/(//g' | sed 's/)//g' | sed 's/ //g') == "active" ]]; then
    VLESS_KILL="${GREEN}Running${NC}";
else
    VLESS_KILL="${RED}Not Running${NC}";
fi
if [[ $(systemctl status trojan-kill | grep Active | awk '{print $2}' | sed 's/(//g' | sed 's/)//g' | sed 's/ //g') == "active" ]]; then
    TROJAN_KILL="${GREEN}Running${NC}";
else
    TROJAN_KILL="${RED}Not Running${NC}";
fi
if [[ $(systemctl status ss-kill | grep Active | awk '{print $2}' | sed 's/(//g' | sed 's/)//g' | sed 's/ //g') == "active" ]]; then
    SS_KILL="${GREEN}Running${NC}";
else
    SS_KILL="${RED}Not Running${NC}";
fi
if [[ $(systemctl status ssh-kill | grep Active | awk '{print $2}' | sed 's/(//g' | sed 's/)//g' | sed 's/ //g') == "active" ]]; then
    SSH_KILL="${GREEN}Running${NC}";
else
    SSH_KILL="${RED}Not Running${NC}";
fi
if [[ $(systemctl status sslh | grep Active | awk '{print $2}' | sed 's/(//g' | sed 's/)//g' | sed 's/ //g') == "active" ]]; then
    SSLH_SST="${GREEN}Running${NC}";
else
    SSLH_SST="${RED}Not Running${NC}";
fi

# // Ram Information
while IFS=":" read -r a b; do
    case $a in
        "MemTotal") ((mem_used+=${b/kB})); mem_total="${b/kB}" ;;
        "Shmem") ((mem_used+=${b/kB}))  ;;
        "MemFree" | "Buffers" | "Cached" | "SReclaimable")
        mem_used="$((mem_used-=${b/kB}))"
    ;;
esac
done < /proc/meminfo
Ram_Usage="$((mem_used / 1024))";
Ram_Total="$((mem_total / 1024))";

if [[ -f /etc/cron.d/auto-backup ]]; then
    STT_EMM="${GREEN}Running${NC}"
else 
    STT_EMM="${RED}Not Running${NC}"
fi

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
dmon="$(vnstat -i eth0 -m | grep "`date +"%b '%y"`" | awk '{print $3" "substr ($4, 1, 1)}')"
umon="$(vnstat -i eth0 -m | grep "`date +"%b '%y"`" | awk '{print $6" "substr ($7, 1, 1)}')"
tmon="$(vnstat -i eth0 -m | grep "`date +"%b '%y"`" | awk '{print $9" "substr ($10, 1, 1)}')"

# // Getting CPU Information
ISP=$(curl -s ipinfo.io/org | cut -d " " -f 2-10 )
CITY=$(curl -s ipinfo.io/city )
Sver=$(cat /home/version)
tele=$(cat /home/contact)
JAM=$(date +%r)
DAY=$(date +%A)
DATE=$(date +%d.%m.%Y)
IPVPS=$(curl -s ipinfo.io/ip )

# // Ver Xray & V2ray
verxray="$(/usr/local/bin/xray -version | awk 'NR==1 {print $2}')"                                                                                                                                                                                                    

# // Bash
shellversion+=" ${BASH_VERSION/-*}" 
versibash=$shellversion

clear
echo -e ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo -e "${WBBG}              [ Maklumat Sistem & Bandwith ]               ${NC}"
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo -e "  Server Uptime       ► $( uptime -p  | cut -d " " -f 2-10000 ) "
echo -e "  Waktu Sekarang      ► $( date -d "0 days" +"%d-%m-%Y | %X" )"
echo -e "  Nama ISP            ► $ISP"
echo -e "  Operating Sistem    ► $( cat /etc/os-release | grep -w PRETTY_NAME | sed 's/PRETTY_NAME//g' | sed 's/=//g' | sed 's/"//g' ) ( $( uname -m) )"
echo -e "  Bandar              ► $CITY"
echo -e "  Ip Vps              ► $IPVPS"
echo -e "  Domain              ► $domain"
echo -e "  Versi Xray          ► $verxray";                                                                                                                                                                                                
echo -e "  Versi Skrip         ► $Sver"
echo -e "  Certificate status  ► Expire pada ${tlsStatus} hari"
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo -e "  Traffic       Hari Ini       Kelmarin        Bulan Ini   ";
echo -e "  Download      $dtoday        $dyest          $dmon       ";
echo -e "  Upload        $utoday        $uyest          $umon       ";
echo -e "  Total         $ttoday        $tyest          $tmon       ";
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo -e "${WBBG}                     [ Servis Status ]                      {NC}"
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo -e "  SSH                 ► ${SSH_STT}";
echo -e "  Dropbear            ► ${DROPBEAR_STT}";
echo -e "  Stunnel4            ► ${STUNNEL4_STT}";
echo -e "  WS-ePro             ► ${WSEPRO_STT}";
echo -e "  OHP OpenSSH         ► ${OHP_1}"
echo -e "  OHP Dropbear        ► ${OHP_2}"
echo -e "  OHP OpenVPN         ► ${OHP_3}"
echo -e "  OHP Universal       ► ${OHP_4}"
echo -e "  Squid Proxy         ► ${SQUID_STT}"
echo -e "  SSLH                ► ${SSLH_SST}"
echo -e "  Nginx               ► ${NGINX_STT}";
echo -e "  Vmess GRPC WS-TLS   ► ${XRAY_TCP}"
echo -e "  Vless GRPC WS-TLS   ► ${XRAY_TCP}"
echo -e "  Trojan GRPC WS TCP  ► ${XRAY_TCP}"
echo -e "  Vmess Ws NonTLS     ► ${XRAY_NTLS}"
echo -e "  Vless Ws NonTLS     ► ${XRAY_NTLS}"
echo -e "  Shadowsocks UDP     ► ${SS_UDP}"
echo -e "  ShadowsocksR        ► ${SSR_UDP}"
echo -e "  HTTP Proxy          ► ${HTTP_STT}"
echo -e "  Socks 4/5 Proxy     ► ${SOCKS_STT}"
echo -e "  WireGuard           ► ${WG_STT}"
echo -e "  OpenVPN TCP         ► ${OVPN_TCP}"
echo -e "  OpenVPN UDP         ► ${OVPN_UDP}"
echo -e "  Vmess AutoKill      ► ${VMESS_KILL}"
echo -e "  Vless AutoKill      ► ${VLESS_KILL}"
echo -e "  Trojan AutoKill     ► ${TROJAN_KILL}"
echo -e "  SS AutoKill         ► ${SS_KILL}"
echo -e "  SSH AutoKill        ► ${SSH_KILL}"
echo -e "  AutoBackup          ► ${STT_EMM}"
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"