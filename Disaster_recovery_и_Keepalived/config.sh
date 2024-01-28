#!/bin/bash

# Переменные
MASTER_IP="192.168.0.110"
BACKUP_IP="192.168.0.114"
FLOATING_IP="192.168.111.15"
WEB_SERVER_PORT=80
INDEX_FILE="/var/www/html/index.nginx-debian.html"

# Проверка, является ли сервер мастером
if ip addr show enp0s3 | grep -q $FLOATING_IP; then
    # Проверка доступности порта
    sudo -u keepalived_user nc -z -w 1 $BACKUP_IP $WEB_SERVER_PORT
    PORT_STATUS=$?

    # Проверка существования файла
    if sudo -u keepalived_user [ -e $INDEX_FILE ]; then
        FILE_STATUS=0
    else
        FILE_STATUS=1
    fi

    # Проверка результатов и вывод статуса
    if [ $PORT_STATUS -eq 0 ] && [ $FILE_STATUS -eq 0 ]; then
        echo "OK: Nginx port is accessible, and index.html file exists."
        exit 0
    else
        echo "ERROR: Nginx port is not accessible or index.html file is missing."
        exit 1
    fi
else
    echo "This server is not the master. Exiting."
    exit 0
fi
