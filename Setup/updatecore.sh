systemctl stop xray-mini@tls > /dev/null 2>&1
systemctl stop xray-mini@nontls > /dev/null 2>&1

cd /usr/local/kaizenvpn/xray-mini;
rm xray-mini;

wget -q -O /usr/local/kaizenvpn/xray-mini "https://raw.githubusercontent.com/rewasu91/scvps/main/Resource/Core/xray-mini";
chmod +x /usr/local/kaizenvpn/xray-mini;

systemctl enable xray-mini@tls;
systemctl enable xray-mini@nontls;

systemctl start xray-mini@tls;
systemctl start xray-mini@nontls;

systemctl restart xray-mini@nontls
systemctl restart xray-mini@tls
