FROM alpine:edge

COPY ./bin /root/

ARG UUID="ffffffff-ffff-ffff-ffff-ffffffffffff"
ARG PORT=18880

RUN apk update && \
    apk add --no-cache curl wget && \
    chmod -R 777 ~/bin

CMD ~/bin/start.sh
