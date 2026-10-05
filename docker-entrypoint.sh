#!/bin/sh
set -eu

mkdir -p storage/framework/cache storage/framework/sessions storage/framework/views storage/logs bootstrap/cache

if [ "${1:-}" = "php" ] && [ "${2:-}" = "artisan" ] && [ "${3:-}" = "serve" ]; then
  php artisan config:cache || true
  php artisan event:cache || true
  php artisan route:cache || true
  php artisan view:cache || true

  nohup php artisan queue:work --tries=3 --sleep=3 --timeout=90 >>storage/logs/queue.log 2>&1 &
  nohup sh -c 'while true; do php artisan schedule:run --no-interaction; sleep 60; done' >>storage/logs/scheduler.log 2>&1 &
fi

exec "$@"
