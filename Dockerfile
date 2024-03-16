FROM debian:stable-slim

ENV DEBIAN_FRONTEND noninteractive
ENV DL_GOOGLE_CHROME_VERSION="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"

RUN set -xe; \
        apt-get update && apt-get install -y --no-install-recommends curl ca-certificates upower; \
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

EXPOSE 80
WORKDIR /root
COPY ./loop-healthcheck .

CMD ["./loop-healthcheck"]
