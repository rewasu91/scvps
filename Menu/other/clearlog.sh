echo > /etc/kaizenvpn/xray-mini-nontls/access.log
echo > /etc/kaizenvpn/xray-mini-nontls/error.log
echo > /etc/kaizenvpn/xray-mini-tls/access.log
echo > /etc/kaizenvpn/xray-mini-tls/error.log
echo > /etc/kaizenvpn/xray-mini-socks/access.log
echo > /etc/kaizenvpn/xray-mini-socks/error.log
echo > /etc/kaizenvpn/xray-mini-shadowsocks/access.log
echo > /etc/kaizenvpn/xray-mini-shadowsocks/error.log
echo > /var/log/syslog
echo "$(date) | Berjaya clear semua log" > /etc/kaizenvpn/clearlog.log
