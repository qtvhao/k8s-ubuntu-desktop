FROM debian:stable-slim

ENV DEBIAN_FRONTEND noninteractive

RUN apt update && apt-get install -y --no-install-recommends wget && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN set -xe; \
        wget -q --no-check-certificate https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb; \
        apt-get purge -y wget; \
        apt update && dpkg -i google-chrome-stable_current_amd64.deb || apt-get -fy --no-install-recommends install; \
        rm google-chrome-stable_current_amd64.deb; \
        apt-get autoremove -y; \
        which google-chrome-stable; \
        apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 80
WORKDIR /root
