# syntax=docker/dockerfile:1
#
ARG IMAGEBASE=frommakefile
#
FROM ${IMAGEBASE}
#
ARG VERSION
#
RUN set -xe \
    && apk add --no-cache --purge -uU \
        supervisor=${VERSION} \
        inotify-tools \
    && sed -i -e 's/^root::/root:!:/' /etc/shadow \
    && rm -rf /var/cache/apk/* /tmp/*
#
VOLUME /etc/supervisor.d
#
ENTRYPOINT ["supervisord"]
#
CMD ["--nodaemon", "--configuration", "/etc/supervisord.conf"]
