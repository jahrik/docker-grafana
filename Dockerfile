FROM arm32v7/ubuntu

ENV ARCH=arm32v7
ENV GRAFANA_VERSION=5.2.4
ENV GRAFANA_ARCH=armhf
ENV TAG=$tag

RUN apt-get update
RUN apt-get install -qq -y \
  libfontconfig \
  sqlite \
  wget \
  tar
RUN wget https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana_${GRAFANA_VERSION}_${GRAFANA_ARCH}.deb -O /tmp/grafana_${GRAFANA_VERSION}_${GRAFANA_ARCH}.deb
RUN dpkg -i /tmp/grafana_${GRAFANA_VERSION}_${GRAFANA_ARCH}.deb
RUN rm /tmp/grafana_${GRAFANA_VERSION}_${GRAFANA_ARCH}.deb

ADD config.ini /grafana/conf/config.ini

RUN        mkdir /data && chmod 777 /data

USER       grafana
EXPOSE     3000
VOLUME     [ "/data" ]
WORKDIR    /usr/share/grafana/

ENTRYPOINT [ "/usr/sbin/grafana-server" ]

CMD        [ "-config=/grafana/conf/config.ini" ]
