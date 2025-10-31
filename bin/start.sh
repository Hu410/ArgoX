#!/bin/sh

wget https://github.com/XTLS/Xray-core/releases/download/v25.10.15/Xray-linux-64.zip
wget -O cloudflared https://github.com/cloudflare/cloudflared/releases/download/2025.9.1/cloudflared-linux-amd64
wget -O caddy_linux_amd64.tar.gz https://github.com/caddyserver/caddy/releases/download/v2.10.2/caddy_2.10.2_linux_amd64.tar.gz

unzip Xray-linux-64.zip
tar -zxvf caddy_linux_amd64.tar.gz
rm -rf README.md LICENSE *.zip *.tar.gz

if [ ! $(pgrep cloudflared) ]; then
    nohup ~/cloudflared tunnel --url http://127.0.0.1:18880 --no-autoupdate > ~/cloudflared.log 2>&1 &
fi

echo "vless://ffffffff-ffff-ffff-ffff-ffffffffffff@cf.0sm.com:443?security=tls&sni=trycloudflare.com&allowInsecure=1&type=ws&path=/&host=trycloudflare.com&encryption=none#ArgoX" > /var/www/sub

tunnel_url=$(cat ~/cloudflared.log | grep -oE "https://.*[a-z]+cloudflare.com" | sed "s#https://##")

sub_url=$(sed -E "s/(host=|sni=|&host=)[^&]*/\1$new_url/g" /var/www/sub)

echo $sub_url > /var/www/sub

nohup ~/caddy run --config ~/Caddyfile > /dev/null 2>&1 &


# if [ ! $(pgrep xray) ]; then
#     nohup ~/bin/xray run -c ~/bin/config.json > ~/run.log 2>&1 &
# fi
