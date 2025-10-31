FROM alpine:edge

COPY bin /root/bin/

ENV PORT=${PORT}
ENV UUID=${UUID}

RUN apk update && \
    apk add --no-cache curl wget && \
    echo $?

CMD ~/bin/start.sh
