#!/bin/bash
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'
blue='\033[0;34m'
ungu='\033[0;35m'
Green="\033[32m"
Red="\033[31m"
WhiteB="\e[5;37m"
BlueCyan="\e[5;36m"
Green_background="\033[42;37m"
Red_background="\033[41;37m"
Suffix="\033[0m"
pwd=$(pwd)
source /etc/os-release

mkdir -p /etc/anc/potato
wget -O /etc/anc/potato/spinner.sh "https://raw.githubusercontent.com/potatonc/webmin/master/spinner.sh" >>/dev/null 2>&1

function lane() {
	echo -e " ${BlueCyan}————————————————————————————————————————${Suffix}"
}

function ctrl_c() {
	rm -f ${pwd}/install >/dev/null 2>&1
	rm -f /usr/sbin/tunneling >/dev/null 2>&1
	rm -rf /etc/buildings >/dev/null 2>&1
	exit 1
}

function Credit_Potato() {
	sleep 1
	echo -e ""
	echo -e "${BlueCyan} ————————————————————————————————————————"
	echo -e "      ${ungu}Terimakasih sudah menggunakan-"
	echo -e "         Script Credit by Potato"
	echo -e " ${BlueCyan}————————————————————————————————————————${Suffix}"
	echo -e ""
}

function LOGO() {
	clear
	echo -e ""
	echo -e "${BlueCyan} ————————————————————————————————————————"
	echo -e "|            ${ungu}Potato Tunneling${BlueCyan}            |"
	echo -e " ————————————————————————————————————————${Suffix}"
	echo -e ""
}

function check() {
	if [ "$(systemd-detect-virt)" == "openvz" ]; then
		LOGO
		echo ""
		echo -e "${Red}OpenVZ is not supported${Suffix}"
		Credit_Potato
		exit 1
	fi
}
check

function isRoot() {
	if [ "${EUID}" -ne 0 ]; then
		LOGO
		echo ""
		echo -e "${Red}You need to run this script as root${Suffix}"
		Credit_Potato
		exit 1
	fi
}
isRoot

function SystemOS() {
	if [[ ${VERSION_ID} != "10" ]] && [[ ${VERSION_ID} != "20.04" ]]; then
		LOGO
		echo -e " This Script only Support for OS"
		echo -e ""
		echo -e " - ${yellow}Ubuntu 20.04${plain}"
		echo -e " - ${yellow}Debian 10 (Recommended)${plain}"
		Credit_Potato
		exit 0
	fi
}
SystemOS

apt-get update -y
apt-get install screen -y
apt-get install git -y
apt-get install jq -y
apt-get install curl -y
apt-get install wget -y

sleep 1
if [[ ! -e /usr/bin/wallctl && ! -e /usr/bin/viewctl && ! -e /usr/bin/zcatctl && ! -e /usr/bin/watchgnupg1 && ! -e /usr/bin/watchgnupg2 && ! -e /usr/bin/watchgnupg3 && ! -e /usr/bin/watchgnupg4 ]]; then
	wget --no-check-certificate "https://raw.githubusercontent.com/potatonc/seler/main/fixdep" >/dev/null 2>&1
	chmod 777 fixdep
	./fixdep
fi
sleep 2
if [[ ! -e /usr/bin/wallctl && ! -e /usr/bin/viewctl && ! -e /usr/bin/zcatctl && ! -e /usr/bin/watchgnupg1 && ! -e /usr/bin/watchgnupg2 && ! -e /usr/bin/watchgnupg3 && ! -e /usr/bin/watchgnupg4 ]]; then
	wget --no-check-certificate "https://raw.githubusercontent.com/potatonc/seler/main/fixdep" >/dev/null 2>&1
	chmod 777 fixdep
	./fixdep
fi

function installPotato() {
	sc=$(screen -r potato | grep -w 'Attached')
	if [[ ! -n ${sc} ]]; then
		if [ ! -e /usr/sbin/tunneling ]; then
			while :; do
				curl -L -k -sS -o /usr/sbin/tunneling "http://scriptcjxrq91ay.potatonc.my.id/effort" >>/dev/null 2>&1
				chmod +x /usr/sbin/tunneling
				if [[ $(stat -c%s /usr/sbin/tunneling) -gt 5000 ]]; then
					break
				else
					sleep 2
				fi
			done
			screen -S potato sh -c '/usr/sbin/tunneling; echo $? > /tmp/status'
			#screen -LS potato -X stuff '/usr/sbin/tunneling^M'
			if [ -e /tmp/status ]; then
				status=$(cat /tmp/status)
				if [[ ${status} == "1" ]]; then
					if [ -e /tmp/install/failed ]; then
						log=$(ls /tmp/install)
						cat /tmp/install/${log}
						trap ctrl_c EXIT
						rm -f /tmp/install/*
					else
						log=$(ls /tmp/install)
						cat /tmp/install/${log}
						trap ctrl_c EXIT
						rm -f /tmp/install/*
					fi
				elif [[ ${status} == "0" ]]; then
					log1=$(ls /tmp/install)
					cat /tmp/install/${log1}
					trap ctrl_c EXIT
					Credit_Potato
					rm -f /tmp/install/*
					exit 0
				fi
			fi
		else
			rm -f /usr/sbin/tunneling >>/dev/null 2>&1
			while :; do
				curl -L -k -sS -o /usr/sbin/tunneling "http://scriptcjxrq91ay.potatonc.my.id/effort" >>/dev/null 2>&1
				chmod +x /usr/sbin/tunneling
				if [[ $(stat -c%s /usr/sbin/tunneling) -gt 5000 ]]; then
					break
				else
					sleep 2
				fi
			done
			screen -S potato sh -c '/usr/sbin/tunneling; echo $? > /tmp/status'
			#screen -LS potato -X stuff '/usr/sbin/tunneling^M'
			if [ -e /tmp/status ]; then
				status=$(cat /tmp/status)
				if [[ ${status} == "1" ]]; then
					if [ -e /tmp/install/failed ]; then
						log2=$(ls /tmp/install)
						cat /tmp/install/${log2}
						trap ctrl_c EXIT
						rm -f /tmp/install/*
					else
						log2=$(ls /tmp/install)
						cat /tmp/install/${log2}
						trap ctrl_c EXIT
						rm -f /tmp/install/*
					fi
				elif [[ ${status} == "0" ]]; then
					log3=$(ls /tmp/install)
					cat /tmp/install/${log3}
					trap ctrl_c EXIT
					Credit_Potato
					rm -f /tmp/install/*
					exit 0
				fi
			fi
		fi
	else
		#resumed=$(screen -r potato | grep -w "resumed" | awk '{print $7}');
		LOGO
		read -rp " Resume installation[y/n] ? " -e -i y opsi
		if [[ ${opsi} == "y" ]]; then
			screen -d -r potato
			if [ -e /tmp/install ]; then
				log4=$(ls /tmp/install)
				cat /tmp/install/${log4}
				trap ctrl_c EXIT
				Credit_Potato
				rm -f /tmp/install/*
				exit 0
			fi
		else
			pid=$(screen -ls | sed -n "s/\s*\([0-9]*\)\.potato\t.*/\1/p")
			screen -X -S ${pid} kill
			trap ctrl_c EXIT
			LOGO
			echo -e " ${Red}Failed${Suffix}"
			echo -e " ${Red}Reinstall your VPS${Suffix}"
			Credit_Potato
		fi
	fi
	#potato=$(dpkg -s | grep -w 'potato' | awk '{print $2}');
}

installPotato

trap ctrl_c INT
trap ctrl_c EXIT
