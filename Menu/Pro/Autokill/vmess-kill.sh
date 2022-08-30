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
# Lesen       : MIT License
# ═══════════════════════════════════════════════════════════════════

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

# ═════════════════════════════════════════════════════════
# // Semak kalau anda sudah running sebagai root atau belum
# ═════════════════════════════════════════════════════════
if [[ "${EUID}" -ne 0 ]]; then
		echo -e " ${ERROR} Sila jalankan skrip ini sebagai root user";
		exit 1
fi

# ═════════════════════════════════════════════════════════════════
# // Menyemak sistem sekiranya terdapat pemasangan yang kurang / No
# ═════════════════════════════════════════════════════════════════
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

# ══════════════════
# // Semak Blacklist
# ══════════════════
export CHK_BLACKLIST=$( wget -qO- --inet4-only 'https://api.kaizenvpn.me/vpn-script/blacklist.php?ip='"${IP_NYA}"'' );
if [[ $( echo $CHK_BLACKLIST | jq -r '.respon_code' ) == "127" ]]; then
    SKIP=true;
else
    clear;
    echo -e "${ERROR} IP Address anda tersenarai dalam Blacklist!";
    exit 1;
fi

# ═══════════════════════════
# // Semak Status Lesen Skrip
# ═══════════════════════════
if [[ -r /etc/kaizenvpn/license-key.kaizenvpn ]]; then
    SKIP=true;
else
    clear;
    echo -e "${ERROR} Terdapat error didalam sistem, semua rosak";
    exit 1;
fi
LCN_KEY=$( cat /etc/kaizenvpn/license-key.kaizenvpn | awk '{print $3}' | sed 's/ //g' );
if [[ $LCN_KEY == "" ]]; then
    clear;
    echo -e "${ERROR} Terdapat error didalam Lesen Skrip";
    exit 1;
fi

export API_REQ_NYA=$( wget -qO- --inet4-only 'https://api.kaizenvpn.me/vpn-script/secret/chk-rnn.php?scrty_key=61716199-7c73-4945-9918-c41133d4c94e&ip_addr='"${IP_NYA}"'&lcn_key='"${LCN_KEY}"'' );
if [[ $( echo ${API_REQ_NYA} | jq -r '.respon_code' ) == "104" ]]; then
    SKIP=true;
else
    clear;
    echo -e "${ERROR} Skrip server membatalkan sambungan";
    exit 1;
fi

# ═════════════════════════════════════
# // Rending Data Lesen Skrip dari json
# ═════════════════════════════════════
export RESPON_CODE=$( echo ${API_REQ_NYA} | jq -r '.respon_code' );
export IP=$( echo ${API_REQ_NYA} | jq -r '.ip' );
export STATUS_IP=$( echo ${API_REQ_NYA} | jq -r '.status2' );
export STATUS_LCN=$( echo ${API_REQ_NYA} | jq -r '.status' );
export LICENSE_KEY=$( echo ${API_REQ_NYA} | jq -r '.license' );
export PELANGGAN_KE=$( echo ${API_REQ_NYA} | jq -r '.id' );
export TYPE=$( echo ${API_REQ_NYA} | jq -r '.type' );
export COUNT=$( echo ${API_REQ_NYA} | jq -r '.count' );
export LIMIT=$( echo ${API_REQ_NYA} | jq -r '.limit' );
export CREATED=$( echo ${API_REQ_NYA} | jq -r '.created' );
export EXPIRED=$( echo ${API_REQ_NYA} | jq -r '.expired' );
export UNLIMITED=$( echo ${API_REQ_NYA} | jq -r '.unlimited' );
export LIFETIME=$( echo ${API_REQ_NYA} | jq -r '.lifetime' );
export STABLE=$( echo ${API_REQ_NYA} | jq -r '.stable' );
export BETA=$( echo ${API_REQ_NYA} | jq -r '.beta' );
export FULL=$( echo ${API_REQ_NYA} | jq -r '.full' );
export LITE=$( echo ${API_REQ_NYA} | jq -r '.lite' );
export NAME=$( echo ${API_REQ_NYA} | jq -r '.name' );

# ══════════════════════════
# // Mengesahkan Lesen Skrip
# ══════════════════════════
if [[ ${LCN_KEY} == $LICENSE_KEY ]]; then
    SKIP=true;
else
    clear;
    echo -e "${ERROR} Lesen Skrip anda tidak sah";
    exit 1;
fi

# ════════════════════════════════════════
# // Mengesahkan Tarikh Expire Lesen Skrip
# ════════════════════════════════════════
if [[ ${LIFETIME} == "true" ]]; then
    SKIP=true;
else
    waktu_sekarang=$(date -d "0 days" +"%Y-%m-%d");
    expired_date="$EXPIRED";
    now_in_s=$(date -d "$waktu_sekarang" +%s);
    exp_in_s=$(date -d "$expired_date" +%s);
    days_left=$(( ($exp_in_s - $now_in_s) / 86400 ));
    if [[ $days_left -lt 0 ]]; then
        clear;
        echo -e "${ERROR} Lesen Skrip anda sudah expire";
        exit 1;
    else
        export DAYS_LEFT=${days_left};
    fi
fi

# ══════════════════════════════════════════════════════════
# // Mengesahkan IP Address anda sudah diaktifkan atau belum
# ══════════════════════════════════════════════════════════
if [[ $STATUS_IP == "active" ]]; then
    SKIP=true;
else
    clear;
    echo -e "${ERROR} IP Address anda belum berdaftar";
    exit 1;
fi

# ═══════════════════════════════════════════════════════════
# // Mengesahkan Lesen Skrip anda sudah diaktifkan atau belum
# ═══════════════════════════════════════════════════════════
if [[ $STATUS_LCN == "active" ]]; then
    SKIP=true;
else
    clear;
    echo -e "${ERROR} Lesen skrip anda belum berdaftar";
    exit 1;
fi

# // For Pro Only
if [[ $TYPE == "Pro" ]]; then
    SKIP=true;
else
    clear;
    echo -e "${ERROR} Autokill avaiable only in Pro License";
    exit 1;
fi

# // Clear Data
clear;

# // Inputing Max Login				
source /etc/sshwsvpn/autokill.conf;
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

if [[ $VMESS == "" ]]; then
        echo -e "$(date) Vmess Autokill No Setuped.";
fi

# // Start
echo "$(date) Autokill Vmess MultiLogin for sshwsvpn Script V1.0 Stable";
echo "$(date) Coded by sshwsvpn ( Version 1.0 Beta )";
echo "$(date) Starting Vmess Autokill Service.";

while true; do
sleep 30
# // Start
grep -c -E "^Vmess " "/etc/xray-mini/client.conf" > /etc/sshwsvpn/jumlah-akun-vmess.db;
grep "^Vmess " "/etc/xray-mini/client.conf" | awk '{print $2}'  > /etc/sshwsvpn/akun-vmess.db;
totalaccounts=`cat /etc/sshwsvpn/akun-vmess.db | wc -l`;
echo "Total Akun = $totalaccounts" > /etc/sshwsvpn/total-akun-vmess.db;
for((i=1; i<=$totalaccounts; i++ ));
do
    # // Username Interval Counting
    username=$( head -n $i /etc/sshwsvpn/akun-vmess.db | tail -n 1 );
    expired=$( grep "^Vmess " "/etc/xray-mini/client.conf" | grep -w $username | head -n1 | awk '{print $3}' );

    # // Creating Cache for access.log
    cat /etc/sshwsvpn/xray-mini-nontls/access.log | tail -n30000 > /etc/sshwsvpn/xray-mini-nontls/cache.log

    # // Configuration user logs
    hariini=`date -d "0 days" +"%Y/%m/%d"`;
    waktu=`date -d "0 days" +"%H:%M"`;
    waktunya=`date -d "0 days" +"%Y/%m/%d %H:%M"`;
    jumlah_baris_log=$( cat /etc/sshwsvpn/xray-mini-nontls/cache.log | grep -w $hariini | grep -w $waktu | grep -w 'accepted' | grep -w $username | wc -l );

    if [[ $jumlah_baris_log -gt $VMESS ]]; then
        cp /etc/xray-mini/tls.json /etc/sshwsvpn/xray-mini-utils/tls-backup.json;
        cat /etc/sshwsvpn/xray-mini-utils/tls-backup.json | jq 'del(.inbounds[2].settings.clients[] | select(.email == "'${username}'"))' > /etc/sshwsvpn/xray-mini-cache.json;
        cat /etc/sshwsvpn/xray-mini-cache.json | jq 'del(.inbounds[5].settings.clients[] | select(.email == "'${username}'"))' > /etc/xray-mini/tls.json;
        cp /etc/xray-mini/nontls.json /etc/sshwsvpn/xray-mini-utils/nontls-backup.json;
        cat /etc/sshwsvpn/xray-mini-utils/nontls-backup.json | jq 'del(.inbounds[0].settings.clients[] | select(.email == "'${username}'"))' > /etc/xray-mini/nontls.json;
        rm -rf /etc/sshwsvpn/vmess/${username};
        sed -i "/\b$username\b/d" /etc/xray-mini/client.conf;
        systemctl restart xray-mini@tls;
        systemctl restart xray-mini@nontls;
        date=`date +"%X"`;
        echo "$(date) ${username} - Multi Login Detected - Killed at ${date}"
        echo "VMESS - $(date) - ${username} - Multi Login Detected - Killed at ${date}" >> /etc/sshwsvpn/autokill.log;
    fi

    # // Creating Cache for access.log
    cat /etc/sshwsvpn/xray-mini-tls/access.log | tail -n30000 > /etc/sshwsvpn/xray-mini-tls/cache.log

    # // Configuration user logs
    hariini=`date -d "0 days" +"%Y/%m/%d"`;
    waktu=`date -d "0 days" +"%H:%M"`;
    waktunya=`date -d "0 days" +"%Y/%m/%d %H:%M"`;
    jumlah_baris_log=$( cat /etc/sshwsvpn/xray-mini-tls/cache.log | grep -w $hariini | grep -w $waktu | grep -w 'accepted' | grep -w $username | wc -l );

    if [[ $jumlah_baris_log -gt $VMESS ]]; then
        cp /etc/xray-mini/tls.json /etc/sshwsvpn/xray-mini-utils/tls-backup.json;
        cat /etc/sshwsvpn/xray-mini-utils/tls-backup.json | jq 'del(.inbounds[2].settings.clients[] | select(.email == "'${username}'"))' > /etc/sshwsvpn/xray-mini-cache.json;
        cat /etc/sshwsvpn/xray-mini-cache.json | jq 'del(.inbounds[5].settings.clients[] | select(.email == "'${username}'"))' > /etc/xray-mini/tls.json;
        cp /etc/xray-mini/nontls.json /etc/sshwsvpn/xray-mini-utils/nontls-backup.json;
        cat /etc/sshwsvpn/xray-mini-utils/nontls-backup.json | jq 'del(.inbounds[0].settings.clients[] | select(.email == "'${username}'"))' > /etc/xray-mini/nontls.json;
        rm -rf /etc/sshwsvpn/vmess/${username};
        sed -i "/\b$username\b/d" /etc/xray-mini/client.conf;
        systemctl restart xray-mini@tls;
        systemctl restart xray-mini@nontls;
        date=`date +"%X"`;
        echo "$(date) ${username} - Multi Login Detected - Killed at ${date}"
        echo "VMESS - $(date) - ${username} - Multi Login Detected - Killed at ${date}" >> /etc/sshwsvpn/autokill.log;
    fi
# // End Function
done
done
