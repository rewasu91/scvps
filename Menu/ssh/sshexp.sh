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
export SCVERSION="$( cat /etc/kaizenvpn/version )";
export EDITION="$( cat /etc/kaizenvpn/edition )";
export AUTHER="KaizenVPN";
export ROOT_DIRECTORY="/etc/kaizenvpn";
export CORE_DIRECTORY="/usr/local/kaizenvpn";
export SERVICE_DIRECTORY="/etc/systemd/system";
export SCRIPT_SETUP_URL="https://raw.githubusercontent.com/rewasu91/scvps/main/setup.sh";
export REPO_URL="https://github.com/rewasu91/scvps";

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

# // Clear Expired User
clear;
hariini=`date +%d-%m-%Y`;
cat /etc/shadow | cut -d: -f1,8 | sed /:$/d > /etc/kaizenvpn/akun-ssh.db
totalaccounts=`cat /etc/kaizenvpn/akun-ssh.db | wc -l` 
echo "Total Akun = $totalaccounts" > /etc/kaizenvpn/total-akun-ssh.db
for((i=1; i<=$totalaccounts; i++ ))
do
    tuserval=`head -n $i /etc/kaizenvpn/akun-ssh.db | tail -n 1`
    username=`echo $tuserval | cut -f1 -d:`
    userexp=`echo $tuserval | cut -f2 -d:`
    userexpireinseconds=$(( $userexp * 86400 ))
    tglexp=`date -d @$userexpireinseconds`             
    tgl=`echo $tglexp |awk -F" " '{print $3}'`
while [ ${#tgl} -lt 2 ]
do
    tgl="0"$tgl
done
while [ ${#username} -lt 15 ]
do
    username=$username" " 
done
    bulantahun=`echo $tglexp |awk -F" " '{print $2,$6}'`
    echo "echo 'User : $username | Expired : $tgl $bulantahun'" >> /etc/kaizenvpn/ssh-user-cache.db
    todaystime=`date +%s`
if [ $userexpireinseconds -ge $todaystime ]; then
    #SKip="true"
	:
else
    # // Successfull Deleted Expired Client
    clear;
    echo -e "";
    echo -e "";
    cowsay -f ghostbusters "SELAMAT DATANG BOSKU.";
    echo -e "";
    echo -e "${CYAN}════════════════════════════════════════════${NC}";
    echo -e "${WBBG}   [ Memadam Akaun Expire SSH & OpenVPN ]   ${NC}";
    echo -e "${CYAN}════════════════════════════════════════════${NC}";
    echo -e "";
    echo "  Username : $username | Expire Pada : $tgl $bulantahun | Dipadam Pada : $hariini" >> /etc/kaizenvpn/ssh-expired-deleted.db
    echo "  Username : $username | Expire Pada : $tgl $bulantahun | Dipadam Pada : $hariini"
    userdel -f $username;
    rm -rf /etc/kaizenvpn/ssh/${username};
fi
done
