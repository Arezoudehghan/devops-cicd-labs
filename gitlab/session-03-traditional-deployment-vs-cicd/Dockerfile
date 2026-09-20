FROM nginx:alpine

COPY index.html /usr/share/nginx/html/index.html
COPY health.html /usr/share/nginx/html/health.html

EXPOSE 80

HEALTHCHECK \
  --interval=5s \
  --timeout=2s \
  --start-period=3s \
  --retries=5 \
  CMD wget -qO- http://127.0.0.1/health.html >/dev/null || exit 1
