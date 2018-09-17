FROM arm32v7/ubuntu

ENV ARCH=arm32v7
ENV GRAFANA_VERSION=$grafana_version
ENV GRAFANA_ARCH=armhf
ENV TAG=$tag

# ENV GF_SECURITY_ADMIN_PASSWORD=admin
# ENV GF_SECURITY_ADMIN_USER=admin \
# ENV GF_PATHS_PROVISIONING=/etc/grafana/provisioning/

# COPY datasources /etc/grafana/provisioning/datasources/
# COPY swarmprom_dashboards.yml /etc/grafana/provisioning/dashboards/
# COPY dashboards /etc/grafana/dashboards/

RUN apt-get update
RUN apt-get install -qq -y \
  sqlite \
  wget \
  tar
RUN wget https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana_${GRAFANA_VERSION}_${GRAFANA_ARCH}.deb -O /tmp/grafana_${GRAFANA_VERSION}_${GRAFANA_ARCH}.deb
RUN apt install -y /tmp/grafana_${GRAFANA_VERSION}_${GRAFANA_ARCH}.deb
RUN rm /tmp/grafana_${GRAFANA_VERSION}_${GRAFANA_ARCH}.deb

ADD config.ini /grafana/conf/config.ini

RUN        mkdir /data && chmod 777 /data

USER       grafana
EXPOSE     3000
VOLUME     [ "/data" ]
WORKDIR    /usr/share/grafana/

ENTRYPOINT [ "/usr/sbin/grafana-server" ]

CMD        [ "-config=/grafana/conf/config.ini" ]
