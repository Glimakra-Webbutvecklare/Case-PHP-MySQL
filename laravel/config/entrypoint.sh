#!/bin/bash
set -e

if [ ! -f ".env" ]; then
    if [ -f ".env.example" ]; then
        cp .env.example .env
        echo "[entrypoint] Copied .env.example to .env"
    fi
fi

if [ -f "composer.json" ] && [ ! -d "vendor" ]; then
    echo "[entrypoint] Running composer install..."
    composer install --no-interaction --optimize-autoloader
fi

if [ -f "package.json" ] && [ ! -d "node_modules" ]; then
    echo "[entrypoint] Running npm install..."
    npm install
fi

if [ -f "vite.config.js" ] && [ ! -d "public/build" ]; then
    echo "[entrypoint] Running npm run build..."
    npm run build
fi

if [ -f ".env" ] && [ -f "artisan" ]; then
    if grep -qE 'APP_KEY=($|[[:space:]]*$)' .env 2>/dev/null; then
        echo "[entrypoint] Generating APP_KEY..."
        php artisan key:generate --force
    fi

    echo "[entrypoint] Waiting for MySQL..."

    DB_HOST=$(grep DB_HOST .env | cut -d= -f2 | tr -d ' ')
    DB_USER=$(grep DB_USERNAME .env | cut -d= -f2 | tr -d ' ')
    DB_PASS=$(grep DB_PASSWORD .env | cut -d= -f2 | tr -d ' ')

    max_retries=30
    while [ $max_retries -gt 0 ]; do
        php -r "
            try {
                new PDO('mysql:host=${DB_HOST}', '${DB_USER}', '${DB_PASS}');
                echo 'connected';
            } catch (\PDOException \$e) {
                // host not up yet
            }
        " 2>/dev/null | grep -q connected && break
        max_retries=$((max_retries - 1))
        sleep 1
    done
    echo "[entrypoint] MySQL is ready (or timeout reached)."

    echo "[entrypoint] Running migrations..."
    php artisan migrate --force || echo "[entrypoint] Migration skipped"
fi

echo "[entrypoint] Setting storage permissions..."
chmod -R 777 /var/www/html/storage /var/www/html/bootstrap/cache

echo "[entrypoint] Starting Apache..."
exec "$@"