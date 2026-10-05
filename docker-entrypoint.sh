#!/bin/sh
set -eu

mkdir -p storage/framework/cache storage/framework/sessions storage/framework/views storage/logs bootstrap/cache

if [ "${1:-}" = "php" ] && [ "${2:-}" = "artisan" ] && [ "${3:-}" = "serve" ]; then
  php artisan config:cache || true
  php artisan event:cache || true
  php artisan route:cache || true
  php artisan view:cache || true

  (
    while true
    do
      php artisan queue:work --tries=3 --sleep=3 --timeout=90 --max-time=3600
      sleep 1
    done
  ) >/proc/1/fd/1 2>&1 &

  php artisan schedule:work >/proc/1/fd/1 2>&1 &
fi

exec "$@"
