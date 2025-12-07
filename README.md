# Monica PRM v4 – Coolify Image

This repo contains a `Dockerfile` plus supporting config files (`nginx.conf`,
`supervisord.conf`) to run **Monica PRM v4** on Coolify. It merges the official
`monica:fpm` image with Nginx into a single container. You still need an
external or separate database (e.g. MariaDB/MySQL).

Application data is persisted in a `monica-data` volume mounted at
`/var/www/html/storage`.

In **Coolify**, the recommended setup is:

- Deploy **one application** based on this repo’s `Dockerfile`.
- Deploy the **database separately** using Coolify’s built-in **MariaDB
  template**. This makes it easy to configure **automatic database backups**
  through Coolify’s UI.

## Example `docker-compose.yml`

```yaml
version: "3.9"

services:
  monica:
    build: .
    ports:
      - "8080:80"
    environment:
      APP_ENV: production
      CACHE_DRIVER: database
      DB_DATABASE: monica
      DB_HOST: db
      DB_PASSWORD: secret-password
      DB_USERNAME: monica
      MAIL_ENCRYPTION: tls
      MAIL_FROM_ADDRESS: monica@mydomain.de
      MAIL_FROM_NAME: "Monica PRM"
      MAIL_HOST: smtp.myhost.de
      MAIL_MAILER: smtp
      MAIL_PASSWORD: secret-smtp-password
      MAIL_PORT: 465
      MAIL_USERNAME: monica@mydomain.de
      QUEUE_DRIVER: sync
      SESSION_DRIVER: database
    volumes:
      - monica-data:/var/www/html/storage

  db:
    image: mariadb:11
    environment:
      MYSQL_RANDOM_ROOT_PASSWORD: "true"
      MYSQL_DATABASE: monica
      MYSQL_USER: monica
      MYSQL_PASSWORD: secret-password
    volumes:
      - db-data:/var/lib/mysql

volumes:
  monica-data:
  db-data:
```

For Coolify, use only the `monica` service (built from this repo) and set
`DB_HOST` to the hostname of your Coolify-managed MariaDB service.