# Default values (can be overridden via command line or .env)
DB_HOST ?= localhost
DB_PORT ?= 5432
DB_NAME ?= postgres
DB_USER ?= postgres
DB_PASSWORD ?= 1
DB_SSLMODE ?= disable

MIGRATE_SCRIPT = ./scripts/migrate.sh

.PHONY: up down force version clean help

up:        ## Apply all pending migrations
	@$(MIGRATE_SCRIPT) up

down:      ## Roll back the last migration
	@$(MIGRATE_SCRIPT) down

force:     ## Force set a specific migration version (use: make force version=N)
	@if [ -z "$(version)" ]; then \
		echo "❌ Missing version. Usage: make force version=N"; \
		exit 1; \
	fi
	@$(MIGRATE_SCRIPT) force $(version)

version:   ## Show current migration version
	@$(MIGRATE_SCRIPT) version

clean:     ## Drop all migrations (⚠ dangerous!)
	@$(MIGRATE_SCRIPT) clean

help:      ## Show this help message
	@echo ""
	@echo "Migration commands (via scripts/migrate.sh):"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' Makefile | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-12s\033[0m %s\n", $$1, $$2}'
	@echo ""
	@echo "Example: make force version=3"
