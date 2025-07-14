#!/bin/bash

[ ! "$(whoami)" == "root" ] && echo 'You must be root! try again...' && exit 1

apt update
[ $? -ne 0 ] && echo 'failed to update apt' && return 1
apt upgrade -y
[ $? -ne 0 ] && echo 'failed to upgrade apt' && return 1
apt install python3-certbot
[ $? -ne 0 ] && echo 'failed to install python3-certbot' && return 1
python3-certbot-dns-cloudflare
[ $? -ne 0 ] && echo 'failed to install python3-certbot-dns-cloudflare' && return 1
