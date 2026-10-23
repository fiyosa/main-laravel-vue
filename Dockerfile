# syntax=docker/dockerfile:1

# Base image is built only once from Dockerfile.base
# (manual: podman build -f Dockerfile.base -t laravel-php-base:8.5-pgsql-v1 .)
# Daily deploys only rebuild the application layers below.
FROM laravel-php-base:8.5-pgsql-v1

WORKDIR /app
COPY . .

RUN mkdir -p storage/framework/cache storage/framework/sessions storage/framework/views bootstrap/cache \
    && chmod -R 775 storage bootstrap/cache

COPY supervisord.conf /etc/supervisord.conf
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 8080
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["supervisord", "-c", "/etc/supervisord.conf"]
