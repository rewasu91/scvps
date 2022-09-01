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

domain=$(cat /etc/mon/xray/domain)

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
Sver=$(cat /home/version)
tele=$(cat /home/contact)
JAM=$(date +%r)
DAY=$(date +%A)
DATE=$(date +%d.%m.%Y)
IPVPS=$(curl -s ipinfo.io/ip )

# // Ver Xray & V2ray
verxray="$(/usr/local/bin/xray -version | awk 'NR==1 {print $2}')"                                                                                                                                                                                                    

# // Bash
shellversion+=" ${BASH_VERSION/-*}" 
versibash=$shellversion

clear 
echo -e "\033[5;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[m"
echo -e "\033[30;5;47m                 ⇱ SCRIPT MENU ⇲                  \033[m"
echo -e "\033[5;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[37m"                                                                                    
echo -e "\e[5;33m Isp Name                :${NC}  $ISP"
echo -e "\e[5;33m City                    :${NC}  $CITY"
echo -e "\e[5;33m Domain                  :${NC}  $domain"	
echo -e "\e[5;33m Ip Vps                  :${NC}  $IPVPS"	
echo -e "\e[5;33m Time                    :${NC}  $JAM"
echo -e "\e[5;33m Day                     :${NC}  $DAY"
echo -e "\e[5;33m Date                    :${NC}  $DATE"
echo -e "\e[5;33m Xray Version            :${NC}  ${PURPLE}$verxray${NC}"                                                                                                                                                                                                 
echo -e "\e[5;33m Script Version          :${NC}  ${BLUE}$Sver${NC}"
echo -e "\e[5;33m Telegram                :${NC}  $tele"
echo -e "\e[5;33m Certificate status      :${NC}  \e[33mExpired in ${tlsStatus} days\e[0m"
echo -e "\033[5;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[37m"
echo -e "\e[33m Traffic\e[0m       \e[33mToday      Yesterday     Month   "
echo -e "\e[33m Download\e[0m      $dtoday    $dyest       $dmon   \e[0m"
echo -e "\e[33m Upload\e[0m        $utoday    $uyest       $umon   \e[0m"
echo -e "\e[33m Total\e[0m       \033[0;36m  $ttoday    $tyest       $tmon  \e[0m "
echo -e "\033[5;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[37m"

echo -e "\033[5;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[m"
echo -e "${CYAN}Client Name    :${NC} $name"                                                                                                                                                                                                                        
echo -e "${CYAN}Script Expired :${NC} $exp"                                                                                                                                                                                                                        
echo -e "\033[5;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[37m"






waktu_sekarang=$(date -d "0 days" +"%Y-%m-%d");
expired_date="$EXPIRED";
now_in_s=$(date -d "$waktu_sekarang" +%s);
exp_in_s=$(date -d "$expired_date" +%s);
days_left=$(( ($exp_in_s - $now_in_s) / 86400 ));
STATUS_IPV6=$( cat /etc/sysctl.conf | grep net.ipv6.conf.all.disable_ipv6 | awk '{print $3}' | cut -d " " -f 1 | sed 's/ //g' );

# // Clear
clear
echo -e "${RED_BG}                 VPS / Sytem Information                  ${NC}";
echo -e "Sever Uptime        = $( uptime -p  | cut -d " " -f 2-10000 ) ";
echo -e "Current Time        = $( date -d "0 days" +"%d-%m-%Y | %X" )";
echo -e "Operating System    = $( cat /etc/os-release | grep -w PRETTY_NAME | sed 's/PRETTY_NAME//g' | sed 's/=//g' | sed 's/"//g' ) ( $( uname -m) )";
echo -e "Current Domain      = $( cat /etc/sshwsvpn/domain.txt )";
echo -e "Server IPv4         = ${IP_NYA}";
if [[ $STATUS_IPV6 == "0" ]]; then
IPv6=$( curl -s "https://ipv6.icanhazip.com");
if [[ $IPv6 == "" ]]; then
    IP_V6="Not Supported";
else
    IP_V6="${IPv6}";
fi
echo -e "Server IPv6         = ${IP_V6}";
fi
echo -e "Customer ID         = ${PELANGGAN_KE}";
echo -e "Activation Status   = $(if [[ $STATUS_IP == "active" ]]; then
echo -e "Activated"; else
echo -e "Inactive"; fi
)"
echo -e "License Type        = ${TYPE} Edition";
echo -e "License Issued to   = ${NAME}";
echo -e "License Start       = ${CREATED}";
echo -e "License Limit       = $( if [[ $UNLIMITED == "true" ]]; then
echo -e "Unlimited"; else
echo -e "${COUNT}/${LIMIT} VPS"; fi
)"
echo -e "License Expired     = $( if [[ $LIFETIME == "true" ]]; then
echo -e "Lifetime"; else
echo -e "${EXPIRED} ( $days_left Days Left )"; fi
)"

echo -e "${CYAN}════════════════════════════════════════════${NC}";
echo -e "${WBBG}               [ Menu Utama ]               ${NC}";
echo -e "${CYAN}════════════════════════════════════════════${NC}";

echo -e "════════════════════════════════════════════";
echo -e "               [ Menu Utama ]               ";
echo -e "════════════════════════════════════════════";
echo -e "";
echo -e " [ 01 ] ► Menu SSH & OpenVPN";
echo -e " [ 02 ] ► Menu Vmess";
echo -e " [ 03 ] ► Menu Vless";
echo -e " [ 04 ] ► Menu Trojan";
echo -e " [ 05 ] ► Menu Shadowsocks";
echo -e " [ 06 ] ► Menu ShadowsocksR";
echo -e " [ 07 ] ► Menu Wireguard";
echo -e " [ 08 ] ► Menu Socks 4/5";
echo -e " [ 09 ] ► Menu HTTP";
echo -e "";
echo -e "════════════════════════════════════════════";
echo -e "";
echo -e " [ 10 ] ► Speedtest";
echo -e " [ 11 ] ► Cek RAM";
echo -e " [ 12 ] ► Cek Bandwith";
echo -e " [ 13 ] ► Menukar Timezone";
echo -e " [ 14 ] ► Autokill Menu";
echo -e " [ 15 ] ► Tukar Domain";
echo -e " [ 16 ] ► Renew Certificate";
echo -e " [ 17 ] ► Tambah Email untuk Backup";
echo -e " [ 18 ] ► Backup";
echo -e " [ 19 ] ► Restore";
echo -e " [ 20 ] ► Autobackup";
echo -e " [ 21 ] ► Tukar DNS";
echo -e " [ 22 ] ► Tukar Port";
echo -e " [ 23 ] ► Cek Maklumat Servis & Sistem";
echo -e " [ 24 ] ► Cek versi skrip";
echo -e " [ 25 ] ► Reboot Server";
echo -e " [ 26 ] ► Restart Semua Servis";
echo -e " [ 27 ] ► Update Skrip";
echo -e " [ 28 ] ► Melajukan VPS";
echo -e " [ 29 ] ► Mengaktifkan IPV6";
echo -e " [ 30 ] ► Matikan IPV6";







echo -e "════════════════════════════════════════════════════════════";
echo -e "                      [ Menu Utama ]                        ";
echo -e "════════════════════════════════════════════════════════════";
echo -e "";
echo -e "  [ 01 ] ► Menu SSH & OpenVPN  [ 06 ] ► Menu ShadowsocksR  "
echo -e "  [ 02 ] ► Menu Vmess          [ 07 ] ► Menu Wireguard     "
echo -e "  [ 03 ] ► Menu Vless          [ 08 ] ► Menu Socks 4/5     "
echo -e "  [ 04 ] ► Menu Trojan         [ 09 ] ► Menu HTTP          "
echo -e "  [ 05 ] ► Menu Shadowsocks    [ 10 ] ► Menu Autokill      "





echo -e "${RED_BG}                     Addons Service                       ${NC}";
echo -e "${GREEN}10${YELLOW})${NC}. Benchmark Speed ( Speedtest By Ookla )";
echo -e "${GREEN}11${YELLOW})${NC}. Checking Ram Usage";
echo -e "${GREEN}12${YELLOW})${NC}. Checking Bandwidth Usage";
echo -e "${GREEN}13${YELLOW})${NC}. Change Timezone";
echo -e "${GREEN}14${YELLOW})${NC}. Change License Key";
echo -e "${GREEN}15${YELLOW})${NC}. Autokill Menu | For Pro Only";
echo -e "${GREEN}16${YELLOW})${NC}. Change Domain / Host";

echo -e "${GREEN}17${YELLOW})${NC}. Renew SSL Certificate";
echo -e "${GREEN}18${YELLOW})${NC}. Add Email For Backup";
echo -e "${GREEN}19${YELLOW})${NC}. Backup VPN Client";
echo -e "${GREEN}20${YELLOW})${NC}. Restore VPN Client";
echo -e "${GREEN}21${YELLOW})${NC}. Auto Backup VPN Client";
echo -e "${GREEN}22${YELLOW})${NC}. DNS Changer";
echo -e "${GREEN}23${YELLOW})${NC}. Change Port For SSH & XRay";
echo -e "${GREEN}24${YELLOW})${NC}. System & Service Information";
echo -e "${GREEN}25${YELLOW})${NC}. Check Script Version";
echo -e "${GREEN}26${YELLOW})${NC}. Reboot Your Server";
echo -e "${GREEN}27${YELLOW})${NC}. Restarting All Service";
echo -e "${GREEN}28${YELLOW})${NC}. Update Your Script Version";
echo -e "${GREEN}29${YELLOW})${NC}. SpeedUP Your VPS";
echo -e "${GREEN}30${YELLOW})${NC}. Enable IPv6 Support";
echo -e "${GREEN}31${YELLOW})${NC}. Disable IPv6 Support";
echo -e "";

read -p "Input Your Choose ( 1-31 ) : " choosemu

case $choosemu in
    # // VPN Menu
    1) ssh-menu ;;
    2) vmess-menu ;;
    3) vless-menu ;;
    4) trojan-menu ;;
    5) ss-menu ;;
    6) ssr-menu ;;
    7) wg-menu ;;
    8) socks-menu ;;
    9) http-menu ;;

    # // Other
    10) clear && speedtest ;;
    11) clear && ram-usage ;;
    12) clear && vnstat ;;
    13)
        clear;
        echo -e "${RED_BG}                    Timezone Changer                       ${NC}";
        echo -e "${GREEN}1${YELLOW})${NC}. Asia / Jakarta / Indonesia ( GMT+7 )"
        echo -e "${GREEN}2${YELLOW})${NC}. Asia / Kuala Lumpur / Malaysia ( GMT+8 )"
        echo -e "${GREEN}3${YELLOW})${NC}. America / Chicago / US Central ( GMT-6 )"

        read -p "Choose one : " soefiewjfwefw
        if [[ $soefiewjfwefw == "1" ]]; then
                ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime;
                clear;
                echo -e "${OKEY} Successfull Set time to Jakarta ( GMT +7 )";
                exit 1;
        elif [[ $soefiewjfwefw == "2" ]]; then
                ln -fs /usr/share/zoneinfo/Asia/Kuala_Lumpur /etc/localtime;
                clear;
                echo -e "${OKEY} Successfull Set time to Malaysia ( GMT +8 )";
                exit 1;
        elif [[ $soefiewjfwefw == "2" ]]; then
                ln -fs /usr/share/zoneinfo/America/Chicago /etc/localtime;
                clear;
                echo -e "${OKEY} Successfull Set time to Malaysia ( GMT +8 )";
                exit 1;
        else
                clear;
                sleep 2;
                echo -e "${ERROR} Please Choose One option"
                menu;
        fi
    ;;
    14) autokill-menu ;;
    15) 
        clear;
        read -p "Input Your New Domain : " new_domains
        if [[ $new_domains == "" ]]; then
            clear;
            sleep 2;
            echo -e "${ERROR} Please Input New Domain for contitune";
            menu;
        fi

        # // Stopping Xray nontls
        systemctl stop xray-mini@nontls > /dev/null 2&>1

        # // Input Domain To VPS
        echo "$new_domains" > /etc/sshwsvpn/domain.txt;
        domain=$( cat /etc/sshwsvpn/domain.txt );

        # // Making Certificate
        clear;
        echo -e "${OKEY} Starting Generating Certificate";
        rm -rf /root/.acme.sh;
        mkdir -p /root/.acme.sh;
        wget -q -O /root/.acme.sh/acme.sh "https://releases.sshwsvpn.me/vpn-script/Resource/Core/acme.sh";
        chmod +x /root/.acme.sh/acme.sh;
        sudo /root/.acme.sh/acme.sh --register-account -m vpn-script@sshwsvpn.me;
        sudo /root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256 -ak ec-256;

        # // Successfull Change Path to xray
        key_path_default=$( cat /etc/xray-mini/tls.json | jq '.inbounds[0].streamSettings.xtlsSettings.certificates[]' | jq -r '.certificateFile' );
        cp /etc/xray-mini/tls.json /etc/xray-mini/tls.json_temp;
        cat /etc/xray-mini/tls.json_temp | jq 'del(.inbounds[0].streamSettings.xtlsSettings.certificates[] | select(.certificateFile == "'${key_path_default}'"))' > /etc/xray-mini/tls2.json_temp;
        cat /etc/xray-mini/tls2.json_temp | jq '.inbounds[0].streamSettings.xtlsSettings.certificates += [{"certificateFile": "'/root/.acme.sh/${domain}_ecc/fullchain.cer'","keyFile": "'/root/.acme.sh/${domain}_ecc/${domain}.key'"}]' > /etc/xray-mini/tls.json;
        rm -rf /etc/xray-mini/tls2.json_temp;
        rm -rf /etc/xray-mini/tls.json_temp;

        # // Restart
        systemctl restart xray-mini@tls > /dev/null 2>&1
        systemctl restart xray-mini@nontls > /dev/null 2>&1

        # // Success
        echo -e "${OKEY} Your Domain : $domain";
        sleep 2;
        clear;
        echo -e "${OKEY} Successfull Change Domain to $domain";
        exit 1;
    ;;
    16) 
        domain=$(cat /etc/sshwsvpn/domain.txt);
        if [[ $domain == "" ]]; then
            clear;
            echo -e "${ERROR} VPS Having Something Wrong";
            exit 1
        fi
        echo -e "$OKEY Starting Certificate Renewal";
        sudo /root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256;
    ;;
    17)
        clear;
        read -p "Input Your Email : " email_input
        if [[ $email_input == "" ]]; then
            clear;
            echo -e "${ERROR} Please Input Email to contitune";
            exit 1;
        fi
        echo $email_input > /etc/sshwsvpn/email.txt
        clear;
        echo -e "${OKEY} Successfull Set Email For Backup";
    ;;
    18) backup ;;
    19) restore ;;
    20)
        clear;
        echo -e "${RED_BG}               AutoBackup ( 12:00 & 00:00 )                ${NC}";
        echo -e "${GREEN}1${YELLOW})${NC}. Enable AutoBackup"
        echo -e "${GREEN}2${YELLOW})${NC}. Disable AutoBackup"
        read -p "Choose one " choosenya
        if [[ $choosenya == "1" ]]; then 
            echo "0 */12 * * * root /usr/local/sbin/autobackup" > /etc/cron.d/auto-backup;
            /etc/init.d/cron restart;
            clear;
            echo -e "${OKEY} Successfull Enabled autobackup";
            exit 1;
        elif [[ $choosenya == "2" ]]; then
            rm -rf /etc/cron.d/auto-backup;
            /etc/init.d/cron restart;
            clear;
            echo -e "${OKEY} Successfull Disabled autobackup";
            exit 1;
        else
            clear;
            echo -e "${ERROR} Please Select a valid number"
            sleep 2;
            menu;
        fi
    ;;
    21)
        clear;
        read -p "DNS 1 ( Require )  : " dns1nya
        read -p "DNS 2 ( Optional ) : " dns2nya
        if [[ $dns1nya == "" ]]; then
            clear;
            echo -e "${ERROR} Please Input DNS 1";
            exit 1;
        fi
        if [[ $dns2nya == "" ]]; then
            echo "nameserver $dns1nya" > /etc/resolv.conf
            echo -e "${OKEY} Successful Change DNS To $dns1nya";
            exit 1;
        else
            echo "nameserver $dns1nya" > /etc/resolv.conf
            echo "nameserver $dns2nya" >> /etc/resolv.conf
            echo -e "${OKEY} Successful Change DNS To $dns1nya & $dns2nya";
            exit 1;
        fi
    ;;
    22) change-port ;;
    23) infonya ;;
    24) vpnscript ;;
    25) reboot ;;
    26) systemctl restart xray-mini@tls; systemctl restart xray-mini@nontls; systemctl restart xray-mini@socks; systemctl restart xray-mini@shadowsocks; systemctl restart xray-mini@http;
        systemctl restart nginx; systemctl restart fail2ban; systemctl restart ssr-server; systemctl restart dropbear; systemctl restart ssh; systemctl restart stunnel4; systemctl restart sslh;
        clear; echo -e "${OKEY} Successfull Restarted All Service";
    ;;
    27) cd /root/; wget -q -O /root/update.sh "https://releases.sshwsvpn.me/vpn-script/Stable/update.sh"; chmod +x /root/update.sh; ./update.sh; rm -f /root/update.sh ;;
    28)
            clear
            # // clearlog
            echo -e "${OKEY} Cleaning Your VPS Cache & Logs";
            clearlog;
            sleep 1;

            # // Restart Network
            echo -e "${OKEY} Restarting Your VPS Network";
            systemctl restart networking > /dev/null 2>&1;

            # // Hapus Logs sys
            rm -f /var/log/syslog*
            echo -e "${OKEY} Cleaning Syslogs";
            sleep 1;

            # // Hapus Logs auth di ssh
            if [ -e "/var/log/auth.log" ]; then
                    LOG="/var/log/auth.log";
            elif [ -e "/var/log/secure" ]; then
                    LOG="/var/log/secure";
            fi
            rm -f ${LOG};
            echo -e "${OKEY} Cleaning Auth logs";

            # // Start BBR
            sysctl -p > /dev/null 2>&1;
            echo -e "${OKEY} Successfull Restarting BBR Service";

            # // Done
            sleep 1;
            clear;
            echo -e "${OKEY} Successfull SpeedUP Your VPS";
    ;;
    29) 
            STATUS_IPV6=$( cat /etc/sysctl.conf | grep net.ipv6.conf.all.disable_ipv6 | awk '{print $3}' | cut -d " " -f 1 | sed 's/ //g' );
            if [[ $STATUS_IPV6 == "0" ]]; then
                clear;
                echo -e "${ERROR} IPv6 Already Enabled on this Server";
                exit 1;
            fi
            sed -i 's/net.ipv6.conf.all.disable_ipv6 = 1/net.ipv6.conf.all.disable_ipv6 = 0/g' /etc/sysctl.conf;
            sed -i 's/net.ipv6.conf.default.disable_ipv6 = 1/net.ipv6.conf.default.disable_ipv6 = 0/g' /etc/sysctl.conf;
            sed -i 's/net.ipv6.conf.lo.disable_ipv6 = 1/net.ipv6.conf.lo.disable_ipv6 = 0/g' /etc/sysctl.conf;
            sysctl -p;
            clear;
            echo -e "${OKEY} Successfull Enabled IPv6 Support";
    ;;
    30) 
            STATUS_IPV6=$( cat /etc/sysctl.conf | grep net.ipv6.conf.all.disable_ipv6 | awk '{print $3}' | cut -d " " -f 1 | sed 's/ //g' );
            if [[ $STATUS_IPV6 == "1" ]]; then
                clear;
                echo -e "${ERROR} IPv6 Already Disabled on this Server";
                exit 1;
            fi
            sed -i 's/net.ipv6.conf.all.disable_ipv6 = 0/net.ipv6.conf.all.disable_ipv6 = 1/g' /etc/sysctl.conf;
            sed -i 's/net.ipv6.conf.default.disable_ipv6 = 0/net.ipv6.conf.default.disable_ipv6 = 1/g' /etc/sysctl.conf;
            sed -i 's/net.ipv6.conf.lo.disable_ipv6 = 0/net.ipv6.conf.lo.disable_ipv6 = 1/g' /etc/sysctl.conf;
            sysctl -p;
            clear;
            echo -e "${OKEY} Successfull Disabled IPv6 Support";
    ;;
    *)
        clear;
        sleep 2
        echo -e "${ERROR} Please Input an valid number";
        menu;
    ;;
esac        
