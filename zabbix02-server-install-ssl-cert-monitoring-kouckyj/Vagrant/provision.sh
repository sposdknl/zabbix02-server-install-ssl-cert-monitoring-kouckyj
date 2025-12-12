#!/bin/bash

# Instalace Zabbix repa
wget https://repo.zabbix.com/zabbix/7.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest_7.0+ubuntu24.04_all.deb
dpkg -i zabbix-release_latest_7.0+ubuntu24.04_all.deb
apt update

# Instalace Zabbix komponent a MySQL
apt install -y zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent2
apt install -y mysql-server
apt install -y zabbix-agent2-plugin-mongodb zabbix-agent2-plugin-mssql zabbix-agent2-plugin-postgresql
apt install -y jq

# Inicializace databáze
mysql -uroot -p123456789 <<EOF
CREATE DATABASE zabbix CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
CREATE USER 'zabbix'@'localhost' IDENTIFIED BY '12456789';
GRANT ALL PRIVILEGES ON zabbix.* TO 'zabbix'@'localhost';
SET GLOBAL log_bin_trust_function_creators = 1;
EOF

# Import Zabbix schématu
zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -uzabbix -p12456789 zabbix

# Vypnutí trust funkce
mysql -uroot -p123456789 -e "SET GLOBAL log_bin_trust_function_creators = 0;"

# Nastavení hesla v konfiguraci Zabbix serveru
CONFIG_FILE="/etc/zabbix/zabbix_server.conf"
PASSWORD="12456789"

if grep -q "^DBPassword=" "$CONFIG_FILE"; then
    sed -i "s/^DBPassword=.*/DBPassword=${PASSWORD}/" "$CONFIG_FILE"
else
    echo "DBPassword=${PASSWORD}" >> "$CONFIG_FILE"
fi

echo "DBPassword nastaveno na '${PASSWORD}' v ${CONFIG_FILE}"

# Konfigurace webového frontend
cat <<EOF > /etc/zabbix/web/zabbix.conf.php
<?php
// Zabbix GUI configuration file

\$DB['TYPE']     = 'MYSQL';
\$DB['SERVER']   = 'localhost';
\$DB['PORT']     = '3306';
\$DB['DATABASE'] = 'zabbix';
\$DB['USER']     = 'zabbix';
\$DB['PASSWORD'] = '12456789';

\$ZBX_SERVER      = 'localhost';
\$ZBX_SERVER_PORT = '10051';
\$ZBX_SERVER_NAME = 'Kouckyj Server';

\$IMAGE_FORMAT_DEFAULT = IMAGE_FORMAT_PNG;
?>
EOF

# Přidání jednoduché konfigurace do mysql.ini
cat <<EOF > /etc/mysql/mysql.ini
[mysqld]
# Neškodná ukázková úprava
skip-name-resolve

[client]
# Jen pro ukázku
default-character-set = utf8mb4
EOF


# Restart služeb
systemctl restart zabbix-server zabbix-agent2 apache2
systemctl enable zabbix-server zabbix-agent2 apache2