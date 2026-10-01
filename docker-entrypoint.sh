#!/bin/sh
set -eu

mkdir -p storage/framework/cache storage/framework/sessions storage/framework/views bootstrap/cache

if [ "${1:-}" = "php" ] && [ "${2:-}" = "artisan" ] && [ "${3:-}" = "serve" ]; then
  php artisan config:cache
  php artisan event:cache
  php artisan route:cache
  php artisan view:cache
fi

exec "$@"
