FROM ubuntu:24.04
LABEL org.opencontainers.image.authors="jahrik@gmail.com"

# Set automatically by buildx (amd64/arm64); default for plain docker build
ARG TARGETARCH=amd64

ENV VERSION=13.0.2
ENV GF_INSTALL_PLUGINS=grafana-piechart-panel,grafana-worldmap-panel

# hadolint ignore=DL3008
RUN apt-get update \
  && apt-get install -qq -y --no-install-recommends \
  adduser \
  ca-certificates \
  libfontconfig1 \
  wget \
  && wget -q "https://dl.grafana.com/oss/release/grafana_${VERSION}_${TARGETARCH}.deb" -O /tmp/grafana.deb \
  && dpkg -i /tmp/grafana.deb \
  && rm /tmp/grafana.deb \
  && apt-get purge -y wget \
  && apt-get autoremove -y \
  && rm -rf /var/lib/apt/lists/*

COPY config.ini /grafana/conf/config.ini

RUN mkdir /data && chown -R grafana /data

USER       grafana
EXPOSE     3000
VOLUME     [ "/data" ]
WORKDIR    /usr/share/grafana/

ENTRYPOINT [ "/usr/sbin/grafana-server" ]

CMD        [ "-config=/grafana/conf/config.ini" ]
