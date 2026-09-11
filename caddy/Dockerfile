FROM ghcr.io/zyonzarhaf/unifil-frontend:latest AS frontend

FROM caddy:alpine
COPY --chown=caddy:caddy --from=frontend /srv /srv
COPY --chown=caddy:caddy Caddyfile /etc/caddy/Caddyfile
