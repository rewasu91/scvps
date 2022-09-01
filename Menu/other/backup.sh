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

# // Check Email
if [[ -f /etc/kaizenvpn/email.txt ]]; then
    Skip=true;
else 
    clear;
    echo -e "${ERROR} Sila set email anda terlebih dahulu untuk backup";
    exit 1;
fi
email_mu=$( cat /etc/kaizenvpn/email.txt );

# // Backup your data
rm -rf /root/backup-dir-cache/;
mkdir -p /root/backup-dir-cache/;
cd /root/backup-dir-cache/;
cp -r /etc/xray-mini /root/backup-dir-cache/;
cp -r /etc/kaizenvpn /root/backup-dir-cache/;
cp /etc/passwd /root/backup-dir-cache/;
cp /etc/group /root/backup-dir-cache/;
cp /etc/gshadow /root/backup-dir-cache/;
cp /etc/shadow /root/backup-dir-cache/;
cp -r /etc/wireguard /root/backup-dir-cache/;
echo "$(date)" > created.date;
echo "(C) Copyright by kaizenvpn" > Copyright;
echo "1.0" > script-version;
zip -r backup.zip * > /dev/null 2>&1;
cp backup.zip /root/;
cd;
rm -rf /root/backup-dir-cache/;
date=$(date +"%Y-%m-%d-%H-%M");
cd /root/
mv backup.zip $IP_NYA-$date.zip
tanggal=$(date +"%Y-%m-%d %X");

# // Upload to rclone
wget -q -O /root/.config/rclone/rclone.conf "https://raw.githubusercontent.com/rewasu91/scvps/main/Resource/Config/rclone_conf";
rclone copy "$IP_NYA-$date.zip" kaizenvpn:Script-VPN-Backup/
url=$(rclone link "kaizenvpn:Script-VPN-Backup/$IP_NYA-$date.zip")
F_ID=(`echo $url | grep '^https' | cut -d'=' -f2`)
rm -f /root/.config/rclone/rclone.conf
rm -f $IP_NYA-$date.zip
JAM=$(date +%Z);
JAMNYA=$( echo $JAM | sed 's/+//g' ); 

if [[ $JAMNYA == "08" ]]; then
    JAMNYA="MY";
fi

msgl="===================================<br> VPS Data Backup Information<br>===================================<br>IP : ${IP_NYA}<br>ID Backup : ${F_ID}<br>Date : ${tanggal} ( $JAMNYA )<br>===================================<br>(C) Copyright 2022 By kaizenvpn"
subject_nya="Maklumat Backup | ${IP_NYA}";
email_nya="$email_mu";
html_parse='true';
Result=$( wget -qO- 'https://api.kaizenvpn.me/email/send_mail.php?security_id=1c576a16-eb7f-46fb-91b6-ce0e2d4a98ee&subject='"$subject_nya"'&email='"$email_nya"'&html='"$html_parse"'&message='"$msgl"'' );

if [[ $( echo $Result | jq -r '.respon_code' ) == "107" ]]; then
    clear;
    echo -e "${OKEY} Backup fail telah dihantar ke email ${email_nya}";
    exit 1;
else
    clear;
    echo -e "${ERROR} Terdapat setting yang tidak betul!";
    exit 1;
fi
