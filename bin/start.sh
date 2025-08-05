#!/bin/sh
if [ ! $(pgrep webapp) ]; then
    nohup ~/bin/webapp run -c ~/bin/config.json > /dev/null 2>&1 &
fi

sleep 3

if [ ! $(pgrep cloudflared) ]; then
    nohup ~/bin/cloudflared tunnel --url http://127.0.0.1:18881 --no-autoupdate > ~/bin/argo.log 2>&1 &
fi

sleep 10
cat ~/bin/argo.log | grep -oE "https://.*[a-z]+cloudflare.com" | sed "s#https://##" > /var/www/index.html

~/bin/caddy run --config ~/bin/Caddyfile
