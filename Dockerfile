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
RUN apt-get update && apt-get install -y --no-install-recommends zip unzip && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN set -xe; \
        wget -q --no-check-certificate https://chromedriver.storage.googleapis.com/$(wget -q -O - https://chromedriver.storage.googleapis.com/LATEST_RELEASE)/chromedriver_linux64.zip; \
        apt-get install -y --no-install-recommends unzip; \
        unzip chromedriver_linux64.zip; \
        mv chromedriver /usr/local/bin/; \
        rm chromedriver_linux64.zip; \
        which chromedriver; \
        apt-get purge -y unzip; \
        apt-get autoremove -y; \
        apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN apt-get update && apt-get install -y --no-install-recommends xvfb curl jq && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 80
WORKDIR /root
COPY ./loop-healthcheck .
