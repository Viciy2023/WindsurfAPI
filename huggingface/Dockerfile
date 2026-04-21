FROM node:20-bookworm-slim

ARG LS_DOWNLOAD_URL=__LS_DOWNLOAD_URL__
ARG LS_ARCHIVE_ENTRY_PATH="Windsurf/resources/app/extensions/windsurf/bin/language_server_linux_x64"

ENV DEBIAN_FRONTEND=noninteractive \
    NODE_ENV=production

RUN apt-get update \
  && apt-get install -y --no-install-recommends bash ca-certificates curl tar gzip \
  && rm -rf /var/lib/apt/lists/* \
  && test -n "$LS_DOWNLOAD_URL" \
  && test "$LS_DOWNLOAD_URL" != "__LS_DOWNLOAD_URL__" \
  && mkdir -p /opt/windsurf /opt/windsurf/data/db /tmp/windsurf-workspace \
  && curl -fL "$LS_DOWNLOAD_URL" -o /tmp/windsurf-linux-x64.tar.gz \
  && tar -xzf /tmp/windsurf-linux-x64.tar.gz -C /tmp "$LS_ARCHIVE_ENTRY_PATH" \
  && mv "/tmp/$LS_ARCHIVE_ENTRY_PATH" /opt/windsurf/language_server_linux_x64 \
  && rm -rf /tmp/windsurf-linux-x64.tar.gz /tmp/Windsurf \
  && chmod +x /opt/windsurf/language_server_linux_x64

WORKDIR /app

COPY package.json ./package.json
COPY .env.example ./.env.example
COPY src ./src
COPY entrypoint.sh ./entrypoint.sh
COPY README.md ./README.md

RUN chmod +x /app/entrypoint.sh

EXPOSE 7860

ENTRYPOINT ["bash", "/app/entrypoint.sh"]
