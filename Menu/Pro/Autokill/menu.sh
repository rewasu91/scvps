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
dmon="$(vnstat -i eth0 -m | grep "`date +"%b '%y"`" | awk '{print $3" "substr ($4, 1, 1)}')"
umon="$(vnstat -i eth0 -m | grep "`date +"%b '%y"`" | awk '{print $6" "substr ($7, 1, 1)}')"
tmon="$(vnstat -i eth0 -m | grep "`date +"%b '%y"`" | awk '{print $9" "substr ($10, 1, 1)}')"

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

# ════════════════
# // Menu Autokill
# ════════════════
clear;
echo -e "";
echo -e "";
cowsay -f ghostbusters "SELAMAT DATANG BOSKU.";
echo -e "";
echo -e "${CYAN}════════════════════════════════════════════${NC}";
echo -e "${WBBG}              [ Menu Autokill ]             ${NC}";
echo -e "${CYAN}════════════════════════════════════════════${NC}";
echo -e "";
echo -e " ${CYAN}Autokill Multilogin${NC}";
echo -e " ${GREEN}[ 01 ]${NC} ► Set Vmess Autokill";
echo -e " ${GREEN}[ 02 ]${NC} ► Set Vless Autokill";
echo -e " ${GREEN}[ 03 ]${NC} ► Set Trojan Autokill";
echo -e " ${GREEN}[ 04 ]${NC} ► Set Shadowsocks Autokill";
echo -e " ${GREEN}[ 05 ]${NC} ► Set SSH Multilogin Autokill";
echo -e " ${GREEN}[ 06 ]${NC} ► Mengaktifkan Servis Autokill";
echo -e " ${GREEN}[ 07 ]${NC} ► Menghentikan Servis Autokill";
echo -e " ${GREEN}[ 08 ]${NC} ► Restart Servis Autokill"
echo -e " ${GREEN}[ 09 ]${NC} ► Kembali ke menu utama";
echo "";
echo -e "${CYAN}════════════════════════════════════════════${NC}";
read -p "► Sila masukkan nombor pilihan anda [1-9] : " selection_mu;

case $selection_mu in
    1)
        clear;
        echo -e "                   ${RED} ! WARNING !${NC}"
        echo "Autokill on vmess uses logs as autokill identification";
        echo "please set a minimum of 100-1000 / Minutes";
        echo "default is 1000 you can set it to 200/300/400 for autokill in vmess";
        echo ""
        echo "This configuration is only for those who understand,"
        echo "because if the settings are wrong, you can lose customer data"
        echo ""
        read -p "► Sila set limit untuk Autokill Vmess :" killvmess_coy
        if [[ $killvmess_coy == "" ]]; then
            clear;
            echo -e "${ERROR} ► Sila set limit untuk Autokill Vmess !";
            exit 1;
        fi
        source /etc/kaizenvpn/autokill.conf
        if [[ $VMESS == "" ]]; then
            clear;
            echo -e "${ERROR} Terdapat kesilapan didalam config Autokill anda";
            exit 1;
        fi
        sed -i "s/VMESS=${VMESS}/VMESS=${killvmess_coy}/g" /etc/kaizenvpn/autokill.conf;
        systemctl restart vmess-kill > /dev/null 2>&1;
        clear;
        echo -e "${OKEY} Berjaya mengaktifkan Autokill Vmess";
    ;;
    2)
        clear;
        echo -e "                   ${RED} ! WARNING !${NC}"
        echo "Autokill on vless uses logs as autokill identification";
        echo "please set a minimum of 100-1000 / Minutes";
        echo "default is 1000 you can set it to 200/300/400 for autokill in vless";
        echo ""
        echo "This configuration is only for those who understand,"
        echo "because if the settings are wrong, you can lose customer data"
        echo ""
        read -p "► Sila set limit untuk Autokill Vless : " killvless_coy
        if [[ $killvless_coy == "" ]]; then
            clear;
            echo -e "${ERROR} ► Sila set limit untuk Autokill Vmess !";
            exit 1;
        fi
        source /etc/kaizenvpn/autokill.conf
        if [[ $VLESS == "" ]]; then
            clear;
            echo -e "${ERROR} Terdapat kesilapan didalam config Autokill anda";
            exit 1;
        fi
        sed -i "s/VLESS=${VLESS}/VLESS=${killvless_coy}/g" /etc/kaizenvpn/autokill.conf;
        systemctl restart vless-kill > /dev/null 2>&1;
        clear;
        echo -e "${OKEY} Berjaya mengaktifkan Autokill Vless";
    ;;
    3)
        clear;
        echo -e "                   ${RED} ! WARNING !${NC}"
        echo "Autokill on trojan uses logs as autokill identification";
        echo "please set a minimum of 100-1000 / Minutes";
        echo "default is 1000 you can set it to 200/300/400 for autokill in trojan";
        echo ""
        echo "This configuration is only for those who understand,"
        echo "because if the settings are wrong, you can lose customer data"
        echo ""
        read -p "► Sila set limit untuk Autokill Trojan : " killtrojan_coy
        if [[ $killtrojan_coy == "" ]]; then
            clear;
            echo -e "${ERROR} ► Sila set limit untuk Autokill Trojan !";
            exit 1;
        fi
        source /etc/kaizenvpn/autokill.conf
        if [[ $TROJAN == "" ]]; then
            clear;
            echo -e "${ERROR} Terdapat kesilapan didalam config Autokill anda";
            exit 1;
        fi
        sed -i "s/TROJAN=${TROJAN}/TROJAN=${killtrojan_coy}/g" /etc/kaizenvpn/autokill.conf;
        systemctl restart trojan-kill > /dev/null 2>&1;
        clear;
        echo -e "${OKEY} Berjaya mengaktifkan Autokill Trojan";
    ;;
    4)
        clear;
        echo -e "                   ${RED} ! WARNING !${NC}"
        echo "Autokill on shadowsocks uses logs as autokill identification";
        echo "please set a minimum of 100-1000 / Minutes";
        echo "default is 1000 you can set it to 200/300/400 for autokill in shadowsocks";
        echo ""
        echo "This configuration is only for those who understand,"
        echo "because if the settings are wrong, you can lose customer data"
        echo ""
        read -p "► Sila set limit untuk Autokill Shadowsocks : " killshadowsocks_cuy
        if [[ $killshadowsocks_cuy == "" ]]; then
            clear;
            echo -e "${ERROR} ► Sila set limit untuk Autokill Shadowsocks !";
            exit 1;
        fi
        source /etc/kaizenvpn/autokill.conf
        if [[ $SHADOWSOCKS == "" ]]; then
            clear;
            echo -e "${ERROR} Terdapat kesilapan didalam config Autokill anda";
            exit 1;
        fi
        sed -i "s/SHADOWSOCKS=${SHADOWSOCKS}/SHADOWSOCKS=${killshadowsocks_cuy}/g" /etc/kaizenvpn/autokill.conf;
        systemctl restart ss-kill > /dev/null 2>&1;
        clear;
        echo -e "${OKEY} Berjaya mengaktifkan Autokill Shadowsocks";
    ;;
    5)
        clear;
        read -p "► Sila set limit untuk Autokill SSH : " ssh_kill
        if [[ $ssh_kill == "" ]]; then
            clear;
            echo -e "${ERROR} ► Sila set limit untuk Autokill SSH !";
            exit 1;
        fi
        source /etc/kaizenvpn/autokill.conf
        if [[ $SSH == "" ]]; then
            clear;
            echo -e "${ERROR} Terdapat kesilapan didalam config Autokill anda";
            exit 1;
        fi
        sed -i "s/SSH=${SSH}/SSH=${ssh_kill}/g" /etc/kaizenvpn/autokill.conf;
        systemctl restart ssh-kill > /dev/null 2>&1;
        clear;
        echo -e "${OKEY} Berjaya mengaktifkan Autokill SSH";
    ;;
    6)
        source /etc/kaizenvpn/autokill.conf
        if [[ $ENABLED == "" ]]; then
            clear;
            echo -e "${ERROR} Terdapat kesilapan didalam config Autokill anda";
            exit 1;
        fi
        sed -i "s/ENABLED=${ENABLED}/ENABLED=1/g" /etc/kaizenvpn/autokill.conf;
        systemctl restart vmess-kill > /dev/null 2>&1;
        systemctl restart vless-kill > /dev/null 2>&1;
        systemctl restart ss-kill > /dev/null 2>&1;
        systemctl restart trojan-kill > /dev/null 2>&1;
        systemctl restart ssh-kill > /dev/null 2>&1;
        clear;
        echo -e "${OKEY} Berjaya mengaktifkan servis Autokill";
    ;;
    7)
        source /etc/kaizenvpn/autokill.conf
        if [[ $ENABLED == "" ]]; then
            clear;
            echo -e "${ERROR} Terdapat kesilapan didalam config Autokill anda";
            exit 1;
        fi
        sed -i "s/ENABLED=${ENABLED}/ENABLED=0/g" /etc/kaizenvpn/autokill.conf;
        systemctl restart vmess-kill > /dev/null 2>&1;
        systemctl restart vless-kill > /dev/null 2>&1;
        systemctl restart ss-kill > /dev/null 2>&1;
        systemctl restart trojan-kill > /dev/null 2>&1;
        systemctl restart ssh-kill > /dev/null 2>&1;
        clear;
        echo -e "${OKEY} Berjaya menghentikan servis Autokill";
        exit;
    ;;
    8)
        systemctl restart vmess-kill > /dev/null 2>&1
        systemctl restart vless-kill > /dev/null 2>&1
        systemctl restart ss-kill > /dev/null 2>&1
        systemctl restart trojan-kill > /dev/null 2>&1
        systemctl restart ssh-kill > /dev/null 2>&1
        clear;
        echo -e "${OKEY} Berjaya restart servis Autokill";
        exit 1;
    ;;
    9)
       menu;
    ;;
    *)
        echo -e "${ERROR} Sila masukkan nombor yang betul!";
        sleep 1;
        autokill-menu;
    ;;
esac
