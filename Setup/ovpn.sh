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

# ══════════════════════════════════════
# // Maklumat VPS IP & Network Interface
# ══════════════════════════════════════
MYIP2="s/xxxxxxxxx/$IP_NYA/g";
NET=$(ip route show default | awk '{print $5}');

# ══════════════════
# // Memasang Update
# ══════════════════
apt update -y;
apt upgrade -y;
apt dist-upgrade -y;
apt autoremove -y;
apt clean -y;

# ══════════════════════════════
# // Memasang Alat Bantuan Skrip
# ══════════════════════════════
apt install openvpn unzip -y;
apt install openssl iptables iptables-persistent -y;

# ═════════════════════════════════════════════
# // Memadam OpenVPN Directory & Membuat Semula
# ═════════════════════════════════════════════
rm -r -f /etc/openvpn;
mkdir -p /etc/openvpn;

# ════════════════════════════
# // Setup OpenVPN Main Folder
# ════════════════════════════
cd /etc/openvpn/;
wget -q -O cert.zip "https://raw.githubusercontent.com/rewasu91/scvps/main/Data/ovpn_cert.zip";
unzip -o cert.zip;
rm -f cert.zip;
mkdir -p config;
rm -r -f server;
rm -r -f client;

# ════════════════════════════
# // Chwon Root Directory Data
# ════════════════════════════
chown -R root:root /etc/openvpn/;

# ══════════════════════════════════════════════════
# // Copying OpenVPN Plugin Auth To /usr/lib/openvpn
# ══════════════════════════════════════════════════
mkdir -p /usr/lib/openvpn/;
cp /usr/lib/x86_64-linux-gnu/openvpn/plugins/openvpn-plugin-auth-pam.so /usr/lib/openvpn/openvpn-plugin-auth-pam.so;

# ═══════════════════════════════
# // Enable AUTOSTART For OpenVPN
# ═══════════════════════════════
sed -i 's/#AUTOSTART="all"/AUTOSTART="all"/g' /etc/default/openvpn;

# ════════════════════════════════════
# // Downloading OpenVPN Server Config
# ════════════════════════════════════
wget -q -O /etc/openvpn/tcp.conf "https://raw.githubusercontent.com/rewasu91/scvps/main/Resource/OpenVPN/tcp_conf";
wget -q -O /etc/openvpn/udp.conf "https://raw.githubusercontent.com/rewasu91/scvps/main/Resource/OpenVPN/udp_conf";

# ═══════════════════════════════════════════════════════════════════════
# // Membuang OpenVPN Service lama & Gantikan dengan OpenVPN Service baru
# ═══════════════════════════════════════════════════════════════════════
rm -f /lib/systemd/system/openvpn-server@.service;
wget -q -O /etc/systemd/system/openvpn@.service "https://raw.githubusercontent.com/rewasu91/scvps/main/Resource/Service/openvpn_service";

# ════════════════════════════════════
# Mengaktifkan OpenVPN & Start OpenVPN
# ════════════════════════════════════
systemctl daemon-reload;
systemctl stop openvpn@tcp;
systemctl stop openvpn@udp;
systemctl disable openvpn@tcp;
systemctl disable openvpn@udp;
systemctl enable openvpn@tcp;
systemctl enable openvpn@udp;
systemctl start openvpn@tcp;
systemctl start openvpn@udp;

# ══════════════════════════════
# // Menyemak Status OpenVPN TCP
# ══════════════════════════════
echo -e "${YELLOW}==============================${NC}";
if [[ $( systemctl status openvpn@tcp | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' ) == "running" ]]; then
echo -e "${OKEY} OpenVPN TCP Running !";
else
echo -e "${EROR} OpenVPN TCP Has Been Stopped !";
fi

# ══════════════════════════════
# // Menyemak Status OpenVPN UDP
# ══════════════════════════════
if [[ $( systemctl status openvpn@udp | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' ) == "running" ]]; then
echo -e "${OKEY} OpenVPN UDP Running !";
else
echo -e "${EROR} OpenVPN UDP Has Been Stopped !";
fi

echo -e "${YELLOW}==============================${NC}"
echo -e "${INFO} Enabling OpenVPN Daemon Service.";
echo "Starting Daemon Service For OpenVPN.";
echo "Successfull Started Daemon Service For OpenVPN.";

# ════════════════════════════════════
# // Generating TCP To Cache Directory
# ════════════════════════════════════
wget -q -O /etc/openvpn/config/tcp.ovpn "https://raw.githubusercontent.com/rewasu91/scvps/main/Resource/OpenVPN/tcp_client";
wget -q -O /etc/openvpn/config/udp.ovpn "https://raw.githubusercontent.com/rewasu91/scvps/main/Resource/OpenVPN/udp_client";
wget -q -O /etc/openvpn/config/ssl.ovpn "https://raw.githubusercontent.com/rewasu91/scvps/main/Resource/OpenVPN/ssl_client";

# ══════════════════════════════════════════════════════
# // Menambah IP Address Ke OpenVPN Client Configuration
# ══════════════════════════════════════════════════════
sed -i $MYIP2 /etc/openvpn/config/tcp.ovpn;
sed -i $MYIP2 /etc/openvpn/config/udp.ovpn;
sed -i $MYIP2 /etc/openvpn/config/ssl.ovpn;

# ═════════════════════════════════════════
# // Input Certificate to TCP Client Config
# ═════════════════════════════════════════
echo '<ca>' >> /etc/openvpn/config/tcp.ovpn;
cat /etc/openvpn/ca.crt >> /etc/openvpn/config/tcp.ovpn;
echo '</ca>' >> /etc/openvpn/config/tcp.ovpn;

# ═════════════════════════════════════════
# // Input Certificate to UDP Client Config
# ═════════════════════════════════════════
echo '<ca>' >> /etc/openvpn/config/udp.ovpn;
cat /etc/openvpn/ca.crt >> /etc/openvpn/config/udp.ovpn;
echo '</ca>' >> /etc/openvpn/config/udp.ovpn;

# ═════════════════════════════════════════════
# // Input Certificate to SSL-TCP Client Config
# ═════════════════════════════════════════════
echo '<ca>' >> /etc/openvpn/config/ssl.ovpn;
cat /etc/openvpn/ca.crt >> /etc/openvpn/config/ssl.ovpn;
echo '</ca>' >> /etc/openvpn/config/ssl.ovpn;

# ══════════════════════════
# // Membuat ZIP For OpenVPN
# ══════════════════════════
cd /etc/openvpn/config;
zip all.zip tcp.ovpn udp.ovpn ssl.ovpn;
cp all.zip /etc/kaizenvpn/webserver/;
cp tcp.ovpn /etc/kaizenvpn/webserver/;
cp udp.ovpn /etc/kaizenvpn/webserver/;
cp ssl.ovpn /etc/kaizenvpn/webserver/;
cd /root/;

# ══════════════════════════════════
# // Setting IP Tables to MASQUERADE
# ══════════════════════════════════
iptables -t nat -I POSTROUTING -s 10.10.11.0/24 -o $NET -j MASQUERADE;
iptables -t nat -I POSTROUTING -s 10.10.12.0/24 -o $NET -j MASQUERADE;
iptables-save > /etc/iptables.up.rules;
chmod +x /etc/iptables.up.rules;
iptables-restore -t < /etc/iptables.up.rules;
netfilter-persistent save > /dev/null 2>&1;
netfilter-persistent reload > /dev/null 2>&1;

# ═══════════════════════════════════════════════════
# // Menambah Port Ke IPTables ( OpenVPN 1194 / TCP )
# ═══════════════════════════════════════════════════
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 1194 -j ACCEPT;
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 1194 -j ACCEPT;
iptables-save > /etc/iptables.up.rules;
iptables-restore -t < /etc/iptables.up.rules;
netfilter-persistent save > /dev/null 2>&1;
netfilter-persistent reload > /dev/null 2>&1;

# ═══════════════════════════════════════════════════
# // Menambah Port Ke IPTables ( OpenVPN 1195 / UDP )
# ═══════════════════════════════════════════════════
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 1195 -j ACCEPT;
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 1195 -j ACCEPT;
iptables-save > /etc/iptables.up.rules;
iptables-restore -t < /etc/iptables.up.rules;
netfilter-persistent save > /dev/null 2>&1;
netfilter-persistent reload > /dev/null 2>&1;

# ═══════════════════════════════════════════════════════
# // Menambah Port Ke IPTables ( OpenVPN 1196 / TCP SSL )
# ═══════════════════════════════════════════════════════
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 1196 -j ACCEPT;
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 1196 -j ACCEPT;
iptables-save > /etc/iptables.up.rules;
iptables-restore -t < /etc/iptables.up.rules;
netfilter-persistent save > /dev/null 2>&1;
netfilter-persistent reload > /dev/null 2>&1;

# ═════════════════════════════════════
# // Membuang fail yang tidak digunakan
# ═════════════════════════════════════
rm -f /root/ovpn.sh;

# ══════════
# // Selesai
# ══════════
clear;
echo -e "${OKEY} Berjaya Memasang Servis OpenVPN";
