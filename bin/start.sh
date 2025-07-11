#!/bin/bash
#[ -n $(pgrep webapp) ] && killall webapp
#[ -n $(pgrep cloudflared) ] && killall cloudflared

if [ ! $(pgrep webapp) ]; then
    nohup ~/bin/webapp run -c ~/bin/config.json > /dev/null 2>&1 &
fi

sleep 3

if [ ! $(pgrep cloudflared) ]; then
    nohup ~/bin/cloudflared tunnel --edge-ip-version auto --protocol http2 run --token eyJhIjoiZGM5OWQzYTFmNTU0Yjc1ODk4ZGFhN2RmMWNjYWE3MTUiLCJ0IjoiMmFmMGE1YjYtNDBjMi00MDYzLWI4MjUtOTEwYjJkM2ZhMzU5IiwicyI6Ik1XRmhaVFExWW1JdFpUQmpNaTAwWldZNExXSmxOMkl0TVdaaFl6aG1ZMll4TldFeSJ9 > /dev/null 2>&1 &
fi

~/bin/caddy run --config ~/bin/Caddyfile
