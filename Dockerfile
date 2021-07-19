FROM debian:stable-slim

LABEL org.opencontainers.image.authors="wasabi@dc562.org"
LABEL org.opencontainers.image.vendor="wasabi"
LABEL com.weewx.version=${WEEWX_VERSION}

RUN apt-get update && apt-get install -y libusb-1.0-0 gosu busybox-syslogd tzdata unzip \
 zip sudo mariadb-client python3-mysqldb sqlite3 sqlite python3-pip bash wget rsync

RUN pip3 install pyephem paho-mqtt configobj requests

COPY ./wee*.txt /
COPY ./scripts/setup.sh /setup.sh
COPY ./scripts/entrypoint.sh /entrypoint.sh

#RUN mkdir -p /var/www && mkdir -p /var/lib/weewx/ && ln -s /www /var/www/html && ln -s /data /var/lib/weewx
RUN ./setup.sh && mkdir /data && mkdir /www && rm /setup.sh

VOLUME ["/data", "/www"]

ENTRYPOINT ["./entrypoint.sh"]
CMD ["--run"]
