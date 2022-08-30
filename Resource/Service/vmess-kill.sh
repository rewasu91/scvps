[Unit]
Description=Vmess Auto Kill Service
Documentation=https://github.com/rewasu91/scvps
After=syslog.target network-online.target

[Service]
User=root
NoNewPrivileges=true
ExecStart=/usr/local/kaizenvpn/vmess-auto-kill

[Install]
WantedBy=multi-user.target
