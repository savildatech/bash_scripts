#!/bin/bash

### Certbot requires root, unless you change settings (...and apt) ###
[ ! "$(whoami)" == "root" ] && echo 'You must be root! try again...' && exit 1

run_certbot='0' #change to '1' if you want to run certbot
install_certbot='0' #change to '1' if you want to install certbot
email='your_email@email_domain.com' #change this
wait_seconds='180' #wait (seconds) for dns propagation
ini_file='/home/<user>/.secrets/cloudflare.ini'

### be careful with this script, it doesn't have great validation ###
### Expects one or multiple -d flags with one domain/subdomain each ###
### cloudflare.ini should contain: "dns_cloudflare_api_token = <insert-cloudflare-token-here>" (Exclude quotes) ###

### works on debian/ubuntu ###

if [ "$install_certbot" == '1' ]; then
  apt update
  [ $? -ne 0 ] && echo 'failed to update apt' && exit 1
  apt upgrade -y
  [ $? -ne 0 ] && echo 'failed to upgrade apt' && exit 1
  apt install -y python3-certbot
  [ $? -ne 0 ] && echo 'failed to install python3-certbot' && exit 1
  apt install -y python3-certbot-dns-cloudflare
  [ $? -ne 0 ] && echo 'failed to install python3-certbot-dns-cloudflare' && exit 1
else
  echo "install skipped because install_certbot is not set to '1'."
fi

[ "$run_certbot" -ne '1' ] && echo "run_certbot is not set to '1', exiting..." && exit 0

[ $# -lt 1 ] && echo 'you need to add your -d flag, followed by the (sub)domain you want, supports multiple -d entries' && exit 1

certbot certonly -n --agree-tos \
-m "$email" \
--dns-cloudflare \
--dns-cloudflare-credentials "$ini_file" \
--dns-cloudflare-propagation-seconds "$wait_seconds" \
$@
