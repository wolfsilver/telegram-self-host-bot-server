FROM alpine:3.19 as base


RUN set -x ; cd /root \
  && apk update \
  && apk upgrade \
  && apk add --update alpine-sdk linux-headers git zlib-dev openssl-dev gperf cmake \
  && git clone --recursive https://github.com/tdlib/telegram-bot-api.git \
  && cd telegram-bot-api \
  && rm -rf build \
  && mkdir build \
  && cd build \
  && cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr/local .. \
  && cmake --build . --target install \
  && cd ../.. \
  && ls -l /usr/local/bin/telegram-bot-api*



FROM alpine:3.19

LABEL maintainer="mxoxw.com telegram-bot-api"

RUN set -x ; apk add --no-cache libstdc++
COPY --from=base /usr/local/bin/telegram-bot-api* /usr/local/bin/

ENTRYPOINT [ "telegram-bot-api" ]

CMD ["--local"]
