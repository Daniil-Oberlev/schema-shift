DB_HOST ?= localhost
DB_PORT ?= 5432
DB_NAME ?= postgres
DB_USER ?= postgres
DB_PASSWORD ?= 1
DB_SSLMODE ?= disable

MIGRATIONS_DIR = internal/database/migrations
DB_URL = postgres://$(DB_USER):$(DB_PASSWORD)@$(DB_HOST):$(DB_PORT)/$(DB_NAME)?sslmode=$(DB_SSLMODE)
MIGRATE = migrate -source file://$(MIGRATIONS_DIR) -database $(DB_URL)

.PHONY: up down force version clean help

up:
	@echo "Applying migrations (up)..."
	$(MIGRATE) up
	@echo "Migrations applied successfully"

down:
	@echo "Reverting the last migration (down)..."
	$(MIGRATE) down 1
	@echo "Migration reverted successfully"

force:
	@test -n "$(version)" || { echo "Specify version: make migrate-force version=N"; exit 1; }
	$(MIGRATE) force $(version)

version:
	$(MIGRATE) version

clean:
	@echo "Dropping all migrations..."
	$(MIGRATE) drop
	@echo "All migrations have been dropped"

help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  migrate-up       - Apply all migrations"
	@echo "  migrate-down     - Revert the last migration"
	@echo "  migrate-force    - Force set a migration version (version=N)"
	@echo "  migrate-version  - Show current migration version"
	@echo "  migrate-clean    - Drop all migrations (dangerous!)"
	@echo ""
	@echo "Example:"
	@echo "  make migrate-up DB_HOST=127.0.0.1 DB_PASSWORD=secret"
