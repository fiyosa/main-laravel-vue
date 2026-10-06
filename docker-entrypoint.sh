#!/bin/sh
set -eu

mkdir -p storage/framework/cache storage/framework/sessions storage/framework/views bootstrap/cache

if [ "${1:-}" = "php" ] && [ "${2:-}" = "artisan" ] && [ "${3:-}" = "serve" ]; then
  # php artisan config:clear || true
  # php artisan event:clear || true
  # php artisan route:clear || true
  # php artisan view:clear || true
  # php artisan cache:clear || true
  # php artisan clear-compiled || true

  php artisan config:cache || true
  php artisan event:cache || true
  php artisan route:cache || true
  php artisan view:cache || true

  (
    while true
    do
      php artisan queue:work --tries=3 --sleep=3 --timeout=90 --max-time=3600 || true
      sleep 1
    done
  ) &

  php artisan schedule:work --quiet &
fi

exec "$@"