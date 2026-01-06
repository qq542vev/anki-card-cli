### File: Dockerfile
##
## anki-card-cli用のDockerイメージを組み立てる。
##
## Usage:
##
## ------ Text ------
## docker buildx build -f Dockerfile
## ------------------
##
## Build arg:
##
##   BASE - ベースとするイメージ名。
##   FONTS - インストールするフォント。
##
## Metadata:
##
##   id - ec200ad7-f5c6-4db9-87e8-0958b21b25f2
##   author - <qq542vev at https://purl.org/meta/me/>
##   version - 1.0.0
##   created - 2025-12-11
##   modified - 2026-01-06
##   copyright - Copyright (C) 2025-2025 qq542vev. All rights reserved.
##   license - <AGPL-3.0-only at https://www.gnu.org/licenses/agpl-3.0.txt>
##   conforms-to - <https://docs.docker.com/reference/dockerfile/>
##
## See Also:
##
##   * <Project homepage at https://github.com/qq542vev/anki-card-cli>
##   * <Bag report at https://github.com/qq542vev/anki-card-cli/issues>

ARG BASE="docker.io/library/node:24-trixie-slim"

FROM ${BASE} AS npm

WORKDIR /app

ENV PUPPETEER_SKIP_DOWNLOAD="true"

COPY index.js package.json package-lock.json .

RUN npm ci --production

FROM ${BASE}

ARG BASE

LABEL org.opencontainers.image.base.name="${BASE}"

ENV DEBIAN_FRONTEND="noninteractive"
ENV PUPPETEER_EXECUTABLE_PATH="/usr/bin/chromium"

RUN \
	apt-get update && \
	apt-get install -y --no-install-recommends chromium

ARG FONTS=""
RUN case "${FONTS}" in ?*) apt-get install -y --no-install-recommends ${FONTS} && fc-cache -fv;; esac

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

ARG WORKDIR="/root/anki-card-cli"
WORKDIR "${WORKDIR}"
COPY --from=npm /app "${WORKDIR}"

ENTRYPOINT ["node", "index.js", "--chrome-arg", "--no-sandbox", "--chrome-arg", "--disable-setuid-sandbox"]
