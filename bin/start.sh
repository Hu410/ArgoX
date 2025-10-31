#!/bin/sh
echo "vless://ffffffff-ffff-ffff-ffff-ffffffffffff@cf.0sm.com:443?security=tls&sni=trycloudflare.com&allowInsecure=1&type=ws&path=/&host=trycloudflare.com&encryption=none#ArgoX" > /var/www/sub
nohup ~/caddy run --config ~/Caddyfile > /dev/null 2>&1 &

if [ ! $(pgrep cloudflared) ]; then
    nohup ~/cloudflared tunnel --url http://127.0.0.1:18881 --no-autoupdate > ~/cloudflared.log 2>&1 &
fi

tunnel_url=$(cat ~/cloudflared.log | grep -oE "https://.*[a-z]+cloudflare.com" | sed "s#https://##")
sub_url=$(sed -E "s/(host=|sni=|&host=)[^&]*/\1$new_url/g" /var/www/sub)
echo $sub_url > /var/www/sub

if [ ! $(pgrep xray) ]; then
    nohup ~/bin/xray run -c ~/bin/config.json > ~/xray.log 2>&1 &
fi

tail -f ~/xray.log
