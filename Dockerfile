FROM node:12-alpine

RUN set -eux \
  && npm i -g 'gulp@^4' 'gulp-cli@^2' \
  && npm i -g 'js-yaml@^3' \
  && npm i -g 'browser-sync@^2' \
  && apk add --no-cache python3 rsync \
  && apk add --no-cache --virtual .build-deps build-base git python3-dev \
  && pip3 install --upgrade pip \
  && pip3 install mkdocs \
  && apk del .build-deps \
  && rm -rf /root/.cache /root/.npm /tmp/npm-* /tmp/v8-* /var/cache/apk/* \
  && mkdir -p /_mkdocs/bin

COPY scripts/* /_mkdocs/bin/

ENV NODE_PATH=/usr/local/lib/node_modules

VOLUME /_mkdocs/build
VOLUME /_mkdocs/site
EXPOSE 8080

WORKDIR /docs

CMD [ "/_mkdocs/bin/watch-docs.sh" ]
