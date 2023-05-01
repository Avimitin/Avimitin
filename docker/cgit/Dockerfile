FROM alpine:3.16

RUN apk add --no-cache nginx git cgit fcgiwrap tini curl
ENTRYPOINT ["/sbin/tini", "--"]

RUN mkdir -p /var/git
RUN mkdir -p /run/nginx

COPY asserts/nginx.conf /etc/nginx/nginx.conf
COPY asserts/run.sh /bin/

EXPOSE 80

VOLUME ["/var/git"]
CMD ["/bin/run.sh"]

HEALTHCHECK CMD curl --fail http://`hostname`:80 || exit 1
