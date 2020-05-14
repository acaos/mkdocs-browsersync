#
# Building:
#   docker build -f Dockerfile -t mkdocs-browsersync:latest .
#
# Running (from the directory with your `mkdocs.yml`)
#  docker run --rm -p 8080:8080 -v $(pwd):/docs -it mkdocs-browsersync:latest
#

FROM node:12-alpine

RUN set -eux \
  && npm i -g 'gulp@^4' 'gulp-cli@^2' \
  && npm i -g 'js-yaml@^3' \
  && npm i -g 'browser-sync@^2' \
  && rm -rf /root/.cache /root/.npm /tmp/npm-* /tmp/v8-*

RUN set -eux \
  && apk add --no-cache python3 rsync \
  && apk add --no-cache --virtual .build-deps build-base git python3-dev \
  && pip3 install --upgrade pip \
  && pip3 install mkdocs \
  && apk del .build-deps \
  && rm -rf /root/.cache /var/cache/apk/* \
  && mkdir -p /_mkdocs/bin

COPY scripts/build-docs.sh /_mkdocs/bin
COPY scripts/watch-docs.sh /_mkdocs/bin
COPY scripts/gulpfile.js /_mkdocs/bin

ENV NODE_PATH=/usr/local/lib/node_modules

VOLUME /_mkdocs/build
VOLUME /_mkdocs/site
EXPOSE 8080

WORKDIR /docs

CMD [ "/_mkdocs/bin/watch-docs.sh" ]
