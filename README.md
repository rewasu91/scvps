<h2 align="center">
Autoskrip KaizenVPN
<img src="https://img.shields.io/badge/Version-2.0-blue.svg"></h2>

### STEP PERTAMA
Sila copy skrip dibawah dan paste kedalam VPS anda. Selepas selesai, sistem akan reboot sebentar. Sila tunggu sistem reboot, kemudian sambung step kedua dibawah.

```
apt update && apt upgrade -y --fix-missing && update-grub && sleep 2 && reboot
```

### STEP KEDUA
Sila copy skrip dibawah dan paste kedalam VPS anda. Sekiranya keluar pertanyaan untuk pertama kalinya, sila taip okey. Kemudian, sila tekan ENTER sahaja untuk semua pertanyaan yang berikutnya. Selepas selesai, sistem akan reboot sebentar. Sila tunggu sistem reboot, kemudian sambung step ketiga dibawah.

```
sysctl -w net.ipv6.conf.all.disable_ipv6=1 && sysctl -w net.ipv6.conf.default.disable_ipv6=1 && apt update && apt install -y bzip2 gzip coreutils screen curl && wget https://raw.githubusercontent.com/rewasu91/scvps/main/setup.sh && chmod +x setup.sh && ./setup.sh
```

### STEP KETIGA
Masuk kedalam VPS anda, dan taip Menu. Sila semak status sistem menggunakan Menu nombor 23. Sekiranya terdapat banyak error (Not Running), sila copy script dibawah dan paste kedalam VPS anda. Sila tekan ENTER sahaja untuk semua pertanyaan yang berikutnya.

```
./ssh-ssl.sh
```
