FROM ghcr.io/qtvhao/chrome:main

# Locale settings (japanese)

# RUN locale-gen vi_VN.UTF-8 \
#   && localedef -f UTF-8 -i vi_VN vi_VN
# ENV LANG vi_VN.UTF-8
# ENV LANGUAGE vi_VN:jp
# ENV LC_ALL vi_VN.UTF-8


EXPOSE 80
WORKDIR /root
COPY ./loop-healthcheck .

CMD ["./loop-healthcheck"]
