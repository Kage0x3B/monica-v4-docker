# Monica (php-fpm) + Nginx + Supervisor in one container
FROM monica:fpm-alpine

# Install Nginx and Supervisor
RUN apk add --no-cache nginx supervisor curl

# Copy Nginx and Supervisor configs
COPY nginx.conf /etc/nginx/nginx.conf
COPY supervisord.conf /etc/supervisor.d/supervisord.ini

RUN sed -i 's|^;*error_log = .*|error_log = /proc/self/fd/2|' /usr/local/etc/php-fpm.conf || true

# Symlink storage -> public/storage
RUN ln -sf /var/www/html/storage/app/public /var/www/html/public/storage

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD curl -f http://127.0.0.1 || exit 1

CMD ["supervisord", "-c", "/etc/supervisord.conf"]