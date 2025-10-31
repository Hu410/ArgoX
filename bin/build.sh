#!/bin/sh

wget https://github.com/XTLS/Xray-core/releases/download/v25.10.15/Xray-linux-64.zip
wget -O cloudflared https://github.com/cloudflare/cloudflared/releases/download/2025.9.1/cloudflared-linux-amd64
wget -O caddy_linux_amd64.tar.gz https://github.com/caddyserver/caddy/releases/download/v2.10.2/caddy_2.10.2_linux_amd64.tar.gz

unzip Xray-linux-64.zip
tar -zxvf caddy_linux_amd64.tar.gz
rm -rf README.md LICENSE *.zip *.tar.gz
chmod +x xray caddy cloudflared

cat > config.json <<EOF 
{
  "log": {
    "loglevel": "warning"
  },
  "inbounds": [
    {
      "listen": "0.0.0.0",
      "port": $PORT,
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "$UUID"
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": {
          "path": "/"
        }
      },
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      }
    }
  ],
  "outbounds": [
    {
      "tag": "direct",
      "protocol": "freedom",
      "settings": {}
    },
    {
      "tag": "blocked",
      "protocol": "blackhole",
      "settings": {}
    }
  ],
  "routing": {
    "domainStrategy": "IPIfNonMatch",
    "rules": [
      {
        "type": "field",
        "ip": [
          "geoip:cn",
          "geoip:private"
        ],
        "outboundTag": "blocked"
      }
    ]
  }
}
EOF
