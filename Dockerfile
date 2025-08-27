FROM ubuntu:22.04

COPY bin /root/bin/

ARG UUID="ffffffff-ffff-ffff-ffff-ffffffffffff"
ARG PORT=18880

RUN apt update && \
    apt install -y curl wget && \
    chmod -R 777 ~/bin && \
    mkdir -p /var/www/ && \
    echo "1234567890" >> /var/www/index.html

CMD ~/bin/start.sh
