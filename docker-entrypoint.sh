#!/bin/sh
set -eu

# php artisan config:clear || true
# php artisan event:clear || true
# php artisan route:clear || true
# php artisan view:clear || true
# php artisan cache:clear || true
# php artisan clear-compiled || true
# php artisan optimize:clear || true # short version

# php artisan config:cache || true
# php artisan event:cache || true
# php artisan route:cache || true
# php artisan view:cache || true
php artisan optimize || true #  short version

exec "$@"
