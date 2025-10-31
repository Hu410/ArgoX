FROM alpine:edge

COPY bin/* /root/

ENV PORT=${PORT}
ENV UUID=${UUID}

RUN apk update && \
    apk add --no-cache curl wget && \
    bash start.sh

CMD ["xray", "run", "-c", "/root/config.json"]
