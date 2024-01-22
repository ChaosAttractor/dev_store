FROM nginx:1.25.3

COPY ./rootfs/nginx/nginx.conf /etc/nginx
COPY ./rootfs/nginx/conf.d/default.conf /etc/nginx/conf.d/

HEALTHCHECK --interval=5s --timeout=3s \
  CMD curl -f http://localhost:80/ || exit 1

