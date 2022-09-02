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

# ═══════════════════════════════════════════════════════════════
# // Menghentikan servis terlebih dahulu sekiranya sedang running
# ═══════════════════════════════════════════════════════════════
systemctl stop xray-mini@tls > /dev/null 2>&1
systemctl stop xray-mini@nontls > /dev/null 2>&1

# ═══════════════════════════════════
# // Membuat Folder Untuk Servis Xray
# ═══════════════════════════════════
mkdir -p /usr/local/kaizenvpn/;

# ═════════════════════════════
# // Downloading XRay Mini Core
# ═════════════════════════════
wget -q -O /usr/local/kaizenvpn/xray-mini "https://raw.githubusercontent.com/rewasu91/scvps/main/Resource/Core/xray-mini";
chmod +x /usr/local/kaizenvpn/xray-mini;

# ════════════════════════════════
# // Downloading XRay Mini Service
# ════════════════════════════════
wget -q -O /etc/systemd/system/xray-mini@.service "https://raw.githubusercontent.com/rewasu91/scvps/main/Resource/Service/xray-mini_service";
chmod +x /etc/systemd/system/xray-mini@.service;

# ══════════════════════
# // Memadam Folder Lama
# ══════════════════════
rm -rf /etc/xray-mini/;
rm -rf /etc/kaizenvpn/xray-mini-tls/;
rm -rf /etc/kaizenvpn/xray-mini-nontls/;
rm -rf /etc/kaizenvpn/xray-mini-shadowsocks/;
rm -rf /etc/kaizenvpn/xray-mini-socks/;

# ═══════════════════════════
# // Membuat Folder Xray-Mini
# ═══════════════════════════
mkdir -p /etc/xray-mini/;
mkdir -p /etc/kaizenvpn/xray-mini-nontls/;
mkdir -p /etc/kaizenvpn/xray-mini-tls/;
mkdir -p /etc/kaizenvpn/vmess/;
mkdir -p /etc/kaizenvpn/vless/;
mkdir -p /etc/kaizenvpn/trojan/;
mkdir -p /etc/kaizenvpn/cache/;
mkdir -p /etc/kaizenvpn/xray-mini-utils/;
mkdir -p /etc/kaizenvpn/xray-mini-shadowsocks/;
mkdir -p /etc/kaizenvpn/xray-mini-socks/;
touch /etc/xray-mini/client.conf;

# ══════════════════════════════
# // Mendapatkan maklumat Domain
# ══════════════════════════════
export domain=$( cat /etc/kaizenvpn/domain.txt );

# ══════════════════════════════
# // Downloading XRay TLS Config
# ══════════════════════════════
wget -qO- "https://raw.githubusercontent.com/rewasu91/scvps/main/Resource/Xray-Mini/1.0.Stable/tls_json" | jq '.inbounds[0].streamSettings.xtlsSettings.certificates += [{"certificateFile": "'/root/.acme.sh/${domain}_ecc/fullchain.cer'","keyFile": "'/root/.acme.sh/${domain}_ecc/${domain}.key'"}]' > /etc/xray-mini/tls.json;
wget -q -O /etc/xray-mini/nontls.json "https://raw.githubusercontent.com/rewasu91/scvps/main/Resource/Xray-Mini/1.0.Stable/nontls_json";
wget -q -O /etc/xray-mini/shadowsocks.json "https://raw.githubusercontent.com/rewasu91/scvps/main/Resource/Xray-Mini/1.0.Stable/shadowsocks_json";
wget -q -O /etc/xray-mini/socks.json "https://raw.githubusercontent.com/rewasu91/scvps/main/Resource/Xray-Mini/1.0.Stable/socks_json";
wget -q -O /etc/xray-mini/http.json "https://raw.githubusercontent.com/rewasu91/scvps/main/Resource/Xray-Mini/1.0.Stable/http_json";

# ════════════════════════════
# // Memadam Apache2 kalau ada
# ════════════════════════════
systemctl stop apache2 > /dev/null 2>&1;
apt remove --purge apache2 -y;
apt autoremove -y;

# ════════════════════════════
# // Mengaktifkan XRay Service
# ════════════════════════════
systemctl enable xray-mini@shadowsocks;
systemctl enable xray-mini@tls;
systemctl enable xray-mini@nontls;
systemctl enable xray-mini@socks;
systemctl enable xray-mini@http;
systemctl start xray-mini@shadowsocks;
systemctl start xray-mini@tls;
systemctl start xray-mini@nontls;
systemctl start xray-mini@socks;
systemctl start xray-mini@http;
systemctl restart xray-mini@shadowsocks;
systemctl restart xray-mini@nontls
systemctl restart xray-mini@tls
systemctl restart xray-mini@socks
systemctl restart xray-mini@http

# ═════════════════════════════════════
# // Membuang fail yang tidak digunakan
# ═════════════════════════════════════
rm -f /root/xray-mini.sh;

# ══════════
# // Selesai
# ══════════
clear;
echo -e "${OKEY} Berjaya Memasang Servis Xray-Mini 1.5.5";
