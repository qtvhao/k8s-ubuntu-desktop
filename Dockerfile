FROM debian:stable-slim

RUN apt-get update && apt-get install -y --no-install-recommends procps
RUN echo "" > "/etc/sysctl.d/local.conf"
RUN echo "fs.inotify.max_user_watches=95956992" >> "/etc/sysctl.d/local.conf"
RUN echo "fs.inotify.max_user_instances=32768" >> "/etc/sysctl.d/local.conf"
RUN echo "fs.inotify.max_queued_events=4194304" >> "/etc/sysctl.d/local.conf"

RUN set -xe; \
    apt-get update; \
    which dbus-daemon || apt-get install -y --no-install-recommends dbus; \
    which dbus-daemon; \
    apt-get purge -y --auto-remove; \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* /var/cache/debconf/*-old /var/cache/debconf/*-new /var/cache/debconf/*-dist
RUN mkdir -p /var/run/dbus


ENV DEBIAN_FRONTEND noninteractive
ENV DL_GOOGLE_CHROME_VERSION="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"

RUN set -xe; \
        apt-get update && apt-get install -y --no-install-recommends curl ca-certificates upower chromium; \
        curl -sSL -o google-chrome-stable_current_amd64.deb $DL_GOOGLE_CHROME_VERSION; \
        dpkg -i google-chrome-stable_current_amd64.deb || apt-get -fy --no-install-recommends install; \
        rm google-chrome-stable_current_amd64.deb; \
        which google-chrome-stable; \
        apt-get install -y --no-install-recommends unzip; \
        curl -sSL -o chromedriver_linux64.zip https://chromedriver.storage.googleapis.com/$(curl -sSL https://chromedriver.storage.googleapis.com/LATEST_RELEASE)/chromedriver_linux64.zip; \
        apt-get install -y --no-install-recommends unzip; \
        unzip chromedriver_linux64.zip; \
        mv chromedriver /usr/local/bin/; \
        rm chromedriver_linux64.zip; \
        which chromedriver; \
        apt-get purge -y unzip; \
        apt-get autoremove -y; \
        apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN which socat || apt-get update && apt-get install -y --no-install-recommends socat && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN apt-get update && apt-get install -y samba-client cifs-utils

# Locale settings (japanese)
RUN apt update && apt-get install -y locales task-japanese \
  && locale-gen vi_VN.UTF-8 \
  && localedef -f UTF-8 -i vi_VN vi_VN
ENV LANG vi_VN.UTF-8
ENV LANGUAGE vi_VN:jp
ENV LC_ALL vi_VN.UTF-8

EXPOSE 80
WORKDIR /root
COPY ./loop-healthcheck .

CMD ["./loop-healthcheck"]
