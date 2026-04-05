FROM caddy:2-alpine

COPY Caddyfile /etc/caddy/Caddyfile
COPY *.sh /srv/

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -qO- http://localhost:80/health || exit 1
