FROM alpine:edge

COPY bin/* /root/

ENV PORT=${PORT}
ENV UUID=${UUID}

RUN apk update && \
    apk add --no-cache curl wget unzip && \
    sh ~/build.sh

CMD /root/start.sh
