#!/bin/bash

DB_HOST=${DB_HOST:-localhost}
DB_PORT=${DB_PORT:-5432}
DB_NAME=${DB_NAME:-postgres}
DB_USER=${DB_USER:-postgres}
DB_PASSWORD=${DB_PASSWORD:-1}
DB_SSLMODE=${DB_SSLMODE:-disable}

MIGRATIONS_DIR="internal/database/migrations"

DB_URL="postgres://${DB_USER}:${DB_PASSWORD}@${DB_HOST}:${DB_PORT}/${DB_NAME}?sslmode=${DB_SSLMODE}"

COMMAND=${1:-}
case "$COMMAND" in
    up)
        echo "Применение миграций (up)..."
        migrate -source "file://$MIGRATIONS_DIR" -database "$DB_URL" up
        echo "Миграции успешно применены"
        ;;
    down)
        echo "Откат миграции (down)..."
        migrate -source "file://$MIGRATIONS_DIR" -database "$DB_URL" down 1
        echo "Миграция успешно откачена"
        ;;
    *)
        echo "Использование: $0 [up|down]"
        echo "  up: Применить все миграции"
        echo "  down: Откатить последнюю миграцию"
        exit 1
        ;;
esac
