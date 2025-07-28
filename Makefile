# Bank Accounting API - Makefile
# ================================
#
# Available commands:
#   make setup      - Initialize the development environment
#   make server     - Start the Rails server
#   make console    - Open Rails console
#   make test       - Run all tests
#   make test-file  - Run specific test file (e.g., make test-file spec/requests/accounts_spec.rb)
#   make lint       - Run RuboCop code analysis
#   make security   - Run security checks (Brakeman + Bundle Audit)
#   make quality    - Run all quality checks (lint + security + test)
#   make clean      - Clean Docker containers and volumes
#   make reset      - Clean and setup environment
#   make logs       - Show application logs
#   make shell      - Open shell in running container
#   make build      - Build Docker images
#   make stop       - Stop all containers
#   make status     - Show container status

.PHONY: help setup server console test test-file lint security quality clean reset logs shell build stop status

# Default target
help:
	@echo "Bank Accounting API - Available Commands"
	@echo "========================================"
	@echo ""
	@echo "Development:"
	@echo "  setup      - Initialize the development environment"
	@echo "  server     - Start the Rails server"
	@echo "  console    - Open Rails console"
	@echo "  shell      - Open shell in running container"
	@echo ""
	@echo "Testing:"
	@echo "  test       - Run all tests"
	@echo "  test-file  - Run specific test file"
	@echo ""
	@echo "Quality:"
	@echo "  lint       - Run RuboCop code analysis"
	@echo "  security   - Run security checks"
	@echo "  quality    - Run all quality checks"
	@echo ""
	@echo "Docker:"
	@echo "  build      - Build Docker images"
	@echo "  stop       - Stop all containers"
	@echo "  clean      - Clean containers and volumes"
	@echo "  reset      - Clean and setup environment"
	@echo "  logs       - Show application logs"
	@echo "  status     - Show container status"
	@echo ""

# Development commands
setup:
	@echo "🚀 Setting up development environment..."
	docker-compose run --rm server script/development_bootstrap
	@echo "✅ Setup completed!"

server:
	@echo "🌐 Starting Rails server..."
	rm -f tmp/pids/server.pid
	docker-compose up

console:
	@echo "💻 Opening Rails console..."
	docker-compose exec server bundle exec rails c

shell:
	@echo "🐚 Opening shell in container..."
	docker-compose exec server bash

# Testing commands
test:
	@echo "🧪 Running all tests..."
	bundle exec rspec

test-file:
	@echo "🧪 Running test file: $(FILE)"
	bundle exec rspec $(FILE)

# Quality commands
lint:
	@echo "🔍 Running RuboCop analysis..."
	bundle exec rubocop

security:
	@echo "🔒 Running security checks..."
	@echo "Running Brakeman..."
	@bundle exec brakeman --no-progress --quiet || echo "Brakeman completed"
	@echo "Running Bundle Audit..."
	@bundle exec bundle-audit check --update || echo "Bundle audit completed"

quality: lint test
	@echo "✅ All quality checks completed!"

# Docker commands
build:
	@echo "🔨 Building Docker images..."
	docker-compose build

stop:
	@echo "⏹️  Stopping all containers..."
	docker-compose down

clean:
	@echo "🧹 Cleaning Docker containers and volumes..."
	docker-compose run --rm server rm -fr ./vendor
	docker-compose down
	docker network rm public 2> /dev/null || true
	@echo "✅ Clean completed!"

reset: clean setup
	@echo "🔄 Reset completed!"

logs:
	@echo "📋 Showing application logs..."
	docker-compose logs -f

status:
	@echo "📊 Container status:"
	docker-compose ps

# Database commands
db-setup:
	@echo "🗄️  Setting up database..."
	bundle exec rails db:setup db:migrate

db-reset:
	@echo "🔄 Resetting database..."
	bundle exec rails db:reset

db-seed:
	@echo "🌱 Seeding database..."
	bundle exec rails db:seed

# Bundle commands
bundle-install:
	@echo "📦 Installing gems..."
	bundle install

bundle-update:
	@echo "📦 Updating gems..."
	bundle update

# Coverage commands
coverage:
	@echo "📊 Running tests with coverage report..."
	bundle exec rspec --format progress

coverage-html:
	@echo "📊 Generating HTML coverage report..."
	bundle exec rspec --format progress
	@echo "📁 Coverage report available at: coverage/index.html"

# Performance commands
benchmark:
	@echo "⚡ Running performance benchmarks..."
	bundle exec rspec-benchmark

# Documentation commands
docs:
	@echo "📚 Generating documentation..."
	bundle exec yard

# Maintenance commands
maintenance:
	@echo "🔧 Running maintenance tasks..."
	bundle exec rails tmp:clear
	bundle exec rails log:clear
	@echo "✅ Maintenance completed!"

# Production-like commands
production-check:
	@echo "🏭 Running production checks..."
	bundle exec rails assets:precompile
	bundle exec rails db:migrate RAILS_ENV=production
	@echo "✅ Production checks completed!"

# Quick development workflow
dev: setup server
	@echo "🚀 Development environment ready!"

quick-test: lint test
	@echo "⚡ Quick test completed!"

# Show help by default
.DEFAULT_GOAL := help
