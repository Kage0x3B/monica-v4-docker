# Monica (php-fpm) + Nginx + Supervisor in one container

FROM monica:fpm

# Install Nginx and Supervisor
RUN apt-get update && \
  apt-get install -y nginx supervisor && \
  rm -rf /var/lib/apt/lists/*

# Ensure runtime dirs exist
RUN mkdir -p /run/nginx /var/log/supervisor

# Copy Nginx and Supervisor configs
COPY nginx.conf /etc/nginx/nginx.conf
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Symlink storage -> public/storage
RUN ln -sf /var/www/html/storage/app/public /var/www/html/public/storage

EXPOSE 80

CMD ["supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]