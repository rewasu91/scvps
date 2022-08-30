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
    rm -f /root/ssh-ssl.sh;
    rm -f /root/requirement.sh;
    rm -f /root/nginx.sh;
    rm -f /root/setup.sh;
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

# ══════════════════════════════════
# // Mengganti Pam.d password common
# ══════════════════════════════════
wget -q -O /etc/pam.d/common-password "https://raw.githubusercontent.com/rewasu91/scvps/main/Resource/Config/password";
chmod +x /etc/pam.d/common-password;

# ════════════════════
# // Memasang Dropbear
# ════════════════════
wget -q -O /etc/ssh/sshd_config "https://raw.githubusercontent.com/rewasu91/scvps/main/Resource/Config/sshd_config";
/etc/init.d/ssh restart;
apt install dropbear -y;
wget -q -O /etc/default/dropbear "https://raw.githubusercontent.com/rewasu91/scvps/main/Resource/Config/dropbear_conf";
chmod +x /etc/default/dropbear;
echo "/bin/false" >> /etc/shells;
echo "/usr/sbin/nologin" >> /etc/shells;
wget -q -O /etc/kaizenvpn/banner.txt "https://raw.githubusercontent.com/rewasu91/scvps/main/Resource/Config/banner.txt";
/etc/init.d/dropbear restart;

# ════════════════════
# // Memasang Stunnel4
# ════════════════════
apt install stunnel4 -y
wget -q -O /etc/stunnel/stunnel.conf "https://raw.githubusercontent.com/rewasu91/scvps/main/Resource/Config/stunnel_conf";
wget -q -O /etc/stunnel/stunnel.pem "https://raw.githubusercontent.com/rewasu91/scvps/main/Data/stunnel_cert";
systemctl enable stunnel4;
systemctl start stunnel4;
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
/etc/init.d/stunnel4 restart;

# ═══════════════════
# // Memasang Ws-ePro
# ═══════════════════
wget -q -O /usr/local/kaizenvpn/ws-epro "https://raw.githubusercontent.com/rewasu91/scvps/main/Resource/Core/ws-epro";
chmod +x /usr/local/kaizenvpn/ws-epro;
wget -q -O /etc/systemd/system/ws-epro.service "https://raw.githubusercontent.com/rewasu91/scvps/main/Resource/Service/ws-epro_service";
chmod +x /etc/systemd/system/ws-epro.service;
wget -q -O /etc/kaizenvpn/ws-epro.conf "https://raw.githubusercontent.com/rewasu91/scvps/main/Resource/Config/ws-epro_conf";
chmod 644 /etc/kaizenvpn/ws-epro.conf;
systemctl enable ws-epro;
systemctl start ws-epro;
systemctl restart ws-epro;

# ════════════════
# // Memasang SSLH
# ════════════════
apt install sslh -y;
wget -q -O /lib/systemd/system/sslh.service "https://raw.githubusercontent.com/rewasu91/scvps/main/Resource/Service/sslh_service"
systemctl daemon-reload
systemctl disable sslh > /dev/null 2>&1;
systemctl stop sslh > /dev/null 2>&1;
systemctl enable sslh;
systemctl start sslh;
systemctl restart sslh;

# ═════════════════════════════════════
# // Membuang fail yang tidak digunakan
# ═════════════════════════════════════
rm -f /root/ssh-ssl.sh;

# ══════════
# // Selesai
# ══════════
clear;
echo -e "${OKEY} Berjaya Memasang Servis Stunnel & Dropbear";
