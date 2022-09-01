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

# ══════════════════════════
# // Membuat Akaun Percubaan
# ══════════════════════════
clear;
echo "";
echo -e "${CYAN}════════════════════════════════════════════${NC}";
echo -e "${WBBG}  [ Membuat Akaun Percubaan Wireguard ]     ${NC}";
echo -e "${CYAN}════════════════════════════════════════════${NC}";
echo -e "";
Username="Trial-$( </dev/urandom tr -dc 0-9A-Z | head -c4 )";
Username="$(echo ${Username} | sed 's/ //g' | tr -d '\r' | tr -d '\r\n' )"; # > // Filtering If User Type Space

# // Validating Your Username Input
if [[ $Username == "" ]]; then
    clear;
    echo -e "${EROR} Sila masukkan Username !";
    exit 1;
fi

if [[ $( cat /etc/wireguard/wg0.conf | grep -w $Username ) == "" ]]; then
    Skip=true;
else
    clear;
    echo -e "${ERROR} User ( ${YELLOW}$Username${NC} ) sudah dipakai !";
    exit 1;
fi

# // Read Expired Date
Jumlah_Hari=1;

# // Count Expired Date
exp=`date -d "$Jumlah_Hari days" +"%Y-%m-%d"`;
hariini=`date -d "0 days" +"%Y-%m-%d"`;

# // Load Wiregaurd String
source /etc/wireguard/string-data;

# // Checknig IP Address
LASTIP=$( cat /etc/wireguard/wg0.conf | grep /32 | tail -n1 | awk '{print $3}' | cut -d "/" -f 1 | cut -d "." -f 4 );
if [[ "$LASTIP" = "" ]]; then
	User_IP="10.10.17.2";
else
	User_IP="10.10.17.$((LASTIP+1))";
fi

# // Client DNS
DNS1=8.8.8.8;
DNS2=8.8.4.4;

# // Domain Export
Domain=$( cat /etc/kaizenvpn/domain.txt );

# // Generate Client Key
User_Priv_Key=$(wg genkey);
User_PUB_Key=$(echo "$User_Priv_Key" | wg pubkey);
User_Preshared_Key=$(wg genpsk);

# // Make Client Config
cat > /etc/kaizenvpn/wireguard-cache.tmp << END
[Interface]
PrivateKey = ${User_Priv_Key}
Address = ${User_IP}/24
DNS = ${DNS1},${DNS2}

[Peer]
PublicKey = ${PUB}
PresharedKey = ${User_Preshared_Key}
Endpoint = ${Domain}:${PORT}
AllowedIPs = 0.0.0.0/0,::/0
END

# // Input Data User Ke Wireguard Server
cat >> /etc/wireguard/wg0.conf << END
#DEPAN Username : $Username | Expired : $exp
[Peer]
Publickey = ${User_PUB_Key}
PresharedKey = ${User_Preshared_Key}
AllowedIPs = ${User_IP}/32
#BELAKANG Username : $Username | Expired : $exp

END

# // Make Wireguard cache folder
mkdir -p /etc/kaizenvpn/wireguard/;
rm -rf /etc/kaizenvpn/wireguard/$Username;
mkdir -p /etc/kaizenvpn/wireguard/$Username;

# // Restarting Service & Copy Client data to webserver
systemctl restart "wg-quick@wg0";
sysctl -p
cp /etc/kaizenvpn/wireguard-cache.tmp /etc/kaizenvpn/webserver/wg-client/${Username}.conf;

# ═════════════════════════════════════
# // Maklumat Akaun Percubaan Wireguard
# ═════════════════════════════════════
clear; 
echo "" | tee -a /etc/kaizenvpn/wireguard/${Username}/config.log;
echo -e "${CYAN}════════════════════════════════════════════${NC}" | tee -a /etc/kaizenvpn/wireguard/${Username}/config.log;
echo -e "${WBBG}   [ Maklumat Akaun Percubaan Wireguard ]   ${NC}" | tee -a /etc/kaizenvpn/wireguard/${Username}/config.log;
echo -e "${CYAN}════════════════════════════════════════════${NC}" | tee -a /etc/kaizenvpn/wireguard/${Username}/config.log;
echo -e " Username    ► ${Username}" | tee -a /etc/kaizenvpn/wireguard/${Username}/config.log;
echo -e " Dibuat Pada ► ${hariini}" | tee -a /etc/kaizenvpn/wireguard/${Username}/config.log;
echo -e " Expire Pada ► ${exp}" | tee -a /etc/kaizenvpn/wireguard/${Username}/config.log;
echo -e " IP          ► ${IP}" | tee -a /etc/kaizenvpn/wireguard/${Username}/config.log;
echo -e " Address     ► ${Domain}" | tee -a /etc/kaizenvpn/wireguard/${Username}/config.log;
echo -e "${CYAN}════════════════════════════════════════════${NC}" | tee -a /etc/kaizenvpn/wireguard/${Username}/config.log;
echo -e " Config File = http://${IP}:85/wg-client/${Username}.conf" | tee -a /etc/kaizenvpn/wireguard/${Username}/config.log;
echo -e "${CYAN}════════════════════════════════════════════${NC}" | tee -a /etc/kaizenvpn/wireguard/${Username}/config.log;