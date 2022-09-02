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
    rm -f /root/ovpn.sh;
    rm -f /root/ssh-ssl.sh;
    rm -f /root/requirement.sh;
    rm -f /root/nginx.sh;
    rm -f /root/setup.sh;
    clear
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

# ═════════════════════
# // Memasang Wireguard
# ═════════════════════
OS=$( cat /etc/os-release | grep -w ID | sed 's/ID//g' | sed 's/=//g' | sed 's/"//g' | awk '{print $1}' );
if [[ $OS == "ubuntu" ]]; then
	apt update -y;
	apt upgrade -y;
	apt autoremove -y;
	apt install wireguard -y;
elif [[ $OS == "debian" ]]; then
	echo "deb http://deb.debian.org/debian/ unstable main" >/etc/apt/sources.list.d/unstable.list
	printf 'Package: *\nPin: release a=unstable\nPin-Priority: 90\n' >/etc/apt/preferences.d/limit-unstable
	apt update -y;
	apt upgrade -y;
	apt autoremove -y;
	apt install wireguard-tools -y;
	apt install -y linux-headers-$(uname -r)
fi

# ══════════════════════════════
# // Memasang Alat Bantuan Skrip
# ══════════════════════════════
apt install iptables -y;
apt install iptables-persistent -y;
apt install wireguard-dkms -y;

# ══════════════════════════════
# // Membuat Wireguard Directory
# ══════════════════════════════
rm -rf /etc/wireguard;
mkdir -p /etc/wireguard;
chmod 600 -R /etc/wireguard/;

# ══════════════════════════════
# // Exporting Network Interface
# ══════════════════════════════
export NETWORK_IFACE="$(ip route show to default | awk '{print $5}')";

# ═════════════════════════════════════════════
# // Generating Wiregaurd PUB Key & WG PRIV Key
# ═════════════════════════════════════════════
PRIV_KEY=$(wg genkey);
PUB_KEY=$(echo "$PRIV_KEY" | wg pubkey);

# ═════════════════════════════════════
# // Membuat Wireguard Config Directory
# ═════════════════════════════════════
cat > /etc/wireguard/string-data << END
DIFACE=$NETWORK_IFACE
IFACE=wg0
LOCAL=10.10.17.1
PORT=2048
PRIV=$PRIV_KEY
PUB=$PUB_KEY
END

# ══════════════════════
# // Wireguard Data Load
# ══════════════════════
source /etc/wireguard/string-data;

# ════════════════════════
# // Membuat Server Config
# ════════════════════════
cat > /etc/wireguard/wg0.conf << END
# Wireguard Config By KaizenVPN
# ═══════════════════════════════════════════════════════════════════
# Please do not try to change / modif this config
# This config is tag to wireguard service
# if you modified this the wireguard service will error
# ═══════════════════════════════════════════════════════════════════
# (C) Copyright 2022 By KaizenVPN

# ═══════════════
# // Start Config
# ═══════════════
[Interface]
Address = $LOCAL/24
ListenPort = $PORT
PrivateKey = $PRIV
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o ${DIFACE} -j MASQUERADE;
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o ${DIFACE} -j MASQUERADE;

#WIREGUARD
END

# ═════════════════════════════════
# // Menambah Wireguard Ke IpTables
# ═════════════════════════════════
iptables -t nat -I POSTROUTING -s ${LOCAL}/24 -o ${DIFACE} -j MASQUERADE;
iptables -I INPUT 1 -i wg0 -j ACCEPT;
iptables -I FORWARD 1 -i ${DIFACE} -o wg0 -j ACCEPT;
iptables -I FORWARD 1 -i wg0 -o ${DIFACE} -j ACCEPT;
iptables -I INPUT 1 -i ${DIFACE} -p udp --dport ${PORT} -j ACCEPT;
iptables-save > /etc/iptables.up.rules;
iptables-restore -t < /etc/iptables.up.rules;
netfilter-persistent save;
netfilter-persistent reload;

# ══════════════════════════════════
# // Membuat Client Config Directory
# ══════════════════════════════════
mkdir -p /etc/kaizenvpn/webserver/wg-client/;

# ═════════════════════════
# // Mengaktifkan Wireguard
# ═════════════════════════
systemctl enable systemd-resolved;
systemctl enable wg-quick@wg0;
systemctl start wg-quick@wg0;
systemctl restart wg-quick@wg0;

# ═════════════════════════════════════
# // Membuang fail yang tidak digunakan
# ═════════════════════════════════════
rm -f /root/wg-set.sh;

# ══════════
# // Selesai
# ══════════
clear;
echo -e "${OKEY} Berjaya Memasang Servis Wireguard";
