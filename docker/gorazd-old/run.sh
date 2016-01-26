#!/bin/bash
chown www-data:www-data /app -R
source /etc/apache2/envvars
tail -F /var/log/apache2/* &
# delete the old PID file
rm -rf /run/httpd/* /run/apache2/* /tmp/httpd/*
exec apache2 -D FOREGROUND