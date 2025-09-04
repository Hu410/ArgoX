#!/bin/sh
if [ ! $(pgrep webapp) ]; then
    nohup ~/bin/webapp run -c ~/bin/config.json > ~/run.log 2>&1 &
fi

sleep 3

if [ ! $(pgrep cloudflared) ]; then
    nohup ~/bin/cloudflared tunnel --url http://127.0.0.1:18881 --no-autoupdate > ~/bin/argo.log 2>&1 &
fi

sleep 20
echo "vless://ffffffff-ffff-ffff-ffff-ffffffffffff@cf.0sm.com:443?security=tls&sni=trycloudflare.com&allowInsecure=1&type=ws&path=/&host=trycloudflare.com&encryption=none#ClawCloud" > /var/www/sub
sleep 5
new_url=$(cat ~/bin/argo.log | grep -oE "https://.*[a-z]+cloudflare.com" | sed "s#https://##")
sleep 5
sub_url=$(sed -E "s/(host=|sni=|&host=)[^&]*/\1$new_url/g" /var/www/sub)
sleep 5
echo $sub_url > /var/www/sub

nohup ~/bin/caddy run --config ~/bin/Caddyfile > /dev/null 2>&1 &

tail -f ~/run.log
