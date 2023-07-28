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

function Credit_KaizenVPS() {
	sleep 1
	echo -e ""
	echo -e " ${BlueCyan}————————————————————————————————————————"
	echo -e "      ${ungu}Terima kasih kerana menggunakan"
	echo -e "            Autoskrip KaizenVPS"
	echo -e " ${BlueCyan}————————————————————————————————————————${Suffix}"
	echo -e ""
}

function LOGO() {
	clear
	echo -e ""
	echo -e " ${BlueCyan}————————————————————————————————————————"
	echo -e "|            ${ungu}Autoskrip KaizenVPS${BlueCyan}            |"
	echo -e " ————————————————————————————————————————${Suffix}"
	echo -e ""
}
Credit_KaizenVPS
LOGO
