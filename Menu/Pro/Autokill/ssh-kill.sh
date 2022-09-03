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
    echo -e "${ERROR} Pakej JQ tidak dipasang";
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

# ═════════════════════════════
# // Menyemak Log User SSH Anda
# ═════════════════════════════
if [ -e "/var/log/auth.log" ]; then
        OS=1;
        LOG="/var/log/auth.log";
fi
if [ -e "/var/log/secure" ]; then
        OS=2;
        LOG="/var/log/secure";
fi

# ═══════════════════════════════════════════════════════
# // Mengesahkan lokasi log SSH ada dimana ( ssh / sshd )
# ═══════════════════════════════════════════════════════
if [ $OS -eq 1 ]; then
    # // Restart SSH
	service ssh restart > /dev/null 2>&1;
fi
if [ $OS -eq 2 ]; then
    # // Restart SSHD
	service sshd restart > /dev/null 2>&1;
fi

# ═══════════════════
# // Restart Dropbear
# ═══════════════════
service dropbear restart > /dev/null 2>&1;

# ═════════════════════
# // Inputing Max Login
# ═════════════════════	
source /etc/kaizenvpn/autokill.conf;
if [[ $ENABLED == "0" ]]; then
    clear;
    echo -e "$(date) Autokill is disabled";
    exit 1;
elif [[ $ENABLED == "1" ]]; then
    ENABLECOY=true;
else
    clear;
    echo -e "$(date) Configuration not found";
    exit 1;
fi

MAX=$SSH;
if [[ $MAX == "" ]]; then
        echo -e "$(date) SSH Autokill No Setuped.";
fi

# ════════
# // Start
# ════════
clear;
echo -e "";
echo -e "";
cowsay -f ghostbusters "SELAMAT DATANG BOSKU.";
echo -e "";
echo -e "${CYAN}══════════════════════════════════════════${NC}";
echo -e "${WBBG}        [ Setting SSH Autokill ]          ${NC}";
echo -e "${CYAN}══════════════════════════════════════════${NC}";
echo -e "";
echo "$(date) Autokill SSH Multilogin Versi 2.0 (Multiport).";
echo "$(date) Dipasang oleh KaizenVPN.";
echo "$(date) Memulakan Servis SSH Autokill.";



# ═══════════════
# // Start Daemon
# ═══════════════
while true; do
sleep 30
cat /etc/passwd | grep "/home/" | cut -d":" -f1 > /etc/kaizenvpn/ssh-user.db;
username1=( `cat "/etc/kaizenvpn/ssh-user.db" `);
i="0";
for user in "${username1[@]}"
do
    username[$i]=`echo $user | sed 's/'\''//g'`;
    jumlah[$i]=0;
    i=$i+1;
done
cat $LOG | grep -i dropbear | grep -i "Password auth succeeded" > /etc/kaizenvpn/ssh-autokill-cache.db;
proc=( `ps aux | grep -i dropbear | awk '{print $2}'`);
for PID in "${proc[@]}"
do
cat /etc/kaizenvpn/ssh-autokill-cache.db | grep "dropbear\[$PID\]" > /etc/kaizenvpn/autokill-ssh-cache1.db;
NUM=`cat /etc/kaizenvpn/autokill-ssh-cache1.db | wc -l`;
USER=`cat /etc/kaizenvpn/autokill-ssh-cache1.db | awk '{print $10}' | sed 's/'\''//g'`;
IP=`cat /etc/kaizenvpn/autokill-ssh-cache1.db | awk '{print $12}'`;
if [ $NUM -eq 1 ]; then
i=0;
for user1 in "${username[@]}"
do
    if [ "$USER" == "$user1" ]; then
        jumlah[$i]=`expr ${jumlah[$i]} + 1`;
        pid[$i]="${pid[$i]} $PID";
    fi
    i=$i+1;
done
fi
done
cat $LOG | grep -i sshd | grep -i "Accepted password for" > /etc/kaizenvpn/ssh-autokill-cache.db;
data=( `ps aux | grep "\[priv\]" | sort -k 72 | awk '{print $2}'`);
for PID in "${data[@]}"
do
cat /etc/kaizenvpn/ssh-autokill-cache.db | grep "sshd\[$PID\]" > /etc/kaizenvpn/autokill-ssh-cache1.db;
NUM=`cat /etc/kaizenvpn/autokill-ssh-cache1.db | wc -l`;
USER=`cat /etc/kaizenvpn/autokill-ssh-cache1.db | awk '{print $9}'`;
IP=`cat /etc/kaizenvpn/autokill-ssh-cache1.db | awk '{print $11}'`;
if [ $NUM -eq 1 ]; then
i=0;
for user1 in "${username[@]}"
do
    if [ "$USER" == "$user1" ]; then
        jumlah[$i]=`expr ${jumlah[$i]} + 1`;
        pid[$i]="${pid[$i]} $PID";
    fi
    i=$i+1;
done
fi
done
j="0";
for i in ${!username[*]}
do
    if [ ${jumlah[$i]} -gt $MAX ]; then
        date=`date +"%X"`;
        echo "SSH - $(date) - ${username[$i]} - Multi Login Detected - Killed at ${date}";
        echo "SSH - $(date) - ${username[$i]} - Multi Login Detected - Killed at ${date}" >> /etc/kaizenvpn/autokill.log;
        kill ${pid[$i]};
        pid[$i]="";
        j=`expr $j + 1`;
    fi
done
if [ $j -gt 0 ]; then
    if [ $OS -eq 1 ]; then
        service ssh restart > /dev/null 2>&1;
    fi
    if [ $OS -eq 2 ]; then
        service sshd restart > /dev/null 2>&1;
    fi
        service dropbear restart > /dev/null 2>&1;
        j=0;
fi
done
