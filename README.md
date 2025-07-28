# 🏦 Bank Accounting API

[![Ruby](https://img.shields.io/badge/Ruby-3.4.5-red.svg)](https://ruby-lang.org/)
[![Rails](https://img.shields.io/badge/Rails-8.0.2-red.svg)](https://rubyonrails.org/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15-blue.svg)](https://www.postgresql.org/)
[![Docker](https://img.shields.io/badge/Docker-24.0.0-blue.svg)](https://www.docker.com/)
[![Test Coverage](https://img.shields.io/badge/coverage-100%25-brightgreen.svg)](https://codecov.io/gh/marcelotoledo5000/bank_accounting)
[![RuboCop](https://img.shields.io/badge/RuboCop-passing-brightgreen.svg)](https://github.com/rubocop/rubocop)
[![Security](https://img.shields.io/badge/security-A+-brightgreen.svg)](https://brakemanscanner.org/)

> A robust, secure, and scalable banking API built with Ruby on Rails 8.0.2

## 📋 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Architecture](#-architecture)
- [Tech Stack](#-tech-stack)
- [Quick Start](#-quick-start)
- [API Documentation](#-api-documentation)
- [Development](#-development)
- [Testing](#-testing)
- [Security](#-security)
- [Contributing](#-contributing)
- [License](#-license)

## 🎯 Overview

Bank Accounting API is a comprehensive banking system that provides secure account management, transaction processing, and financial operations. Built with modern Rails practices, it offers a RESTful API for managing users, accounts, deposits, transfers, and account statements.

### Key Highlights

- ✅ **100% Test Coverage** - Comprehensive test suite with RSpec
- 🔒 **Security First** - Basic authentication, input validation, and security headers
- 🚀 **High Performance** - Optimized queries and efficient data handling
- 📊 **Real-time Balance** - Accurate account balance calculations
- 🔄 **Transaction History** - Complete audit trail for all operations
- 🐳 **Docker Ready** - Containerized for easy deployment

## ✨ Features

### Core Banking Operations
- **User Management** - Create and manage user accounts with CPF validation
- **Account Creation** - Automatic account setup with initial balance
- **Deposits** - Secure money deposits with validation
- **Transfers** - Inter-account transfers with balance verification
- **Balance Queries** - Real-time account balance retrieval
- **Transaction History** - Complete statement with transaction details

### Technical Features
- **RESTful API** - Clean, consistent API design
- **Basic Authentication** - Secure user authentication
- **Input Validation** - Comprehensive parameter validation
- **Error Handling** - Detailed error responses
- **Database Transactions** - ACID compliance for financial operations
- **API Documentation** - Complete endpoint documentation

## 🏗️ Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Controllers   │    │     Services     │    │      Models      │
│                 │    │                 │    │                 │
│ • Accounts      │───▶│ • AccountService│───▶│ • User          │
│ • Transactions  │    │ • Transaction   │    │ • Account       │
│ • Users         │    │   Service       │    │ • Transaction   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Concerns      │    │   Serializers   │    │   Validations   │
│                 │    │                 │    │                 │
│ • Response      │    │ • Transaction   │    │ • Account       │
│ • Exception     │    │   Serializer    │    │   Validation    │
│ • Validations   │    └─────────────────┘    │ • User          │
└─────────────────┘                           │   Validation    │
                                              └─────────────────┘
```

## 🛠️ Tech Stack

| Component | Technology | Version |
|-----------|------------|---------|
| **Language** | Ruby | 3.4.5 |
| **Framework** | Rails | 8.0.2 |
| **Database** | PostgreSQL | 15 |
| **Testing** | RSpec | 8.0.1 |
| **Code Quality** | RuboCop | 1.60.0 |
| **Security** | Brakeman | 7.1.0 |
| **Containerization** | Docker | 24.0.0 |
| **CI/CD** | GitHub Actions | Latest |

## 🚀 Quick Start

### Prerequisites

- Ruby 3.4.5+
- PostgreSQL 15+
- Docker & Docker Compose (recommended)

### Option 1: Docker (Recommended)

```bash
# Clone the repository
git clone git@github.com:marcelotoledo5000/bank_accounting.git
cd bank_accounting

# Setup with Docker
make setup      # Development bootstrap, preparing containers
make server     # Start the server
make console    # Start Rails console
make test       # Run all tests
```

### Option 2: Local Development

```bash
# Clone the repository
git clone git@github.com:marcelotoledo5000/bank_accounting.git
cd bank_accounting

# Install dependencies
gem install bundler
bundle install

# Setup database
rails db:setup db:migrate

# Start the server
rails server

# Run tests
bundle exec rspec
```

### Environment Configuration

Update `config/database.yml` for local development:

```yaml
# For Docker
host: db

# For localhost
host: localhost
```

## 📚 API Documentation

### Authentication

All API endpoints require Basic Authentication using CPF and password:

```bash
# Example using curl
curl -X GET "http://localhost:3000/balance" \
  -H "Authorization: Basic $(echo -n '12345678901:password' | base64)" \
  -H "Content-Type: application/json"
```

### Base URL

```
http://localhost:3000
```

### Headers

```
Authorization: Basic <base64_encoded_credentials>
Content-Type: application/json
```

## 🔧 API Endpoints

### Users

#### Create User
```http
POST /users
```

**Request Body:**
```json
{
  "cpf": "12345678901",
  "name": "John Doe",
  "password": "securepassword"
}
```

**Response:**
```json
{
  "id": 1,
  "cpf": "12345678901",
  "name": "John Doe",
  "password_digest": "$2a$12$...",
  "created_at": "2025-07-28T03:00:00.000Z",
  "updated_at": "2025-07-28T03:00:00.000Z"
}
```

#### List Users
```http
GET /users
```

#### Get User
```http
GET /users/:id
```

### Accounts

#### Create Account
```http
POST /accounts
```

**Request Body:**
```json
{
  "user_id": 1
}
```

#### Get Account
```http
GET /accounts/:id
```

#### Get Balance
```http
GET /balance?account_id=1
```

**Response:**
```json
450.0
```

#### Get Statement
```http
GET /statement?account_id=1
```

**Response:**
```json
[
  {
    "date": "2025-07-28T03:00:00.000Z",
    "document": "#1#1",
    "description": "Initial balance",
    "kind": "initial_balance",
    "amount": 0.0
  },
  {
    "date": "2025-07-28T03:15:00.000Z",
    "document": "#1#2",
    "description": "Deposit",
    "kind": "credit",
    "amount": 450.0
  }
]
```

### Transactions

#### Get Transaction
```http
GET /transactions/:id
```

#### Create Deposit
```http
POST /deposit
```

**Request Body:**
```json
{
  "account_id": 1,
  "amount": 450.0
}
```

#### Create Transfer
```http
POST /transfer
```

**Request Body:**
```json
{
  "account_id": 1,
  "destination_account": 2,
  "amount": 150.0
}
```

**Response:**
```json
{
  "message": "Transfer successful"
}
```

## 🧪 Development

### Using Makefile (Recommended)

```bash
# Show all available commands
make help

# Development workflow
make setup      # Initialize environment
make server     # Start server
make console    # Open Rails console
make shell      # Open shell in container

# Testing
make test       # Run all tests
make test-file FILE=spec/requests/accounts_spec.rb  # Run specific test
make coverage   # Run tests with coverage report

# Quality checks
make lint       # Run RuboCop
make security   # Run security checks
make quality    # Run all quality checks (lint + security + test)

# Docker management
make build      # Build Docker images
make clean      # Clean containers and volumes
make reset      # Clean and setup environment
make logs       # Show application logs
make status     # Show container status

# Database operations
make db-setup   # Setup database
make db-reset   # Reset database
make db-seed    # Seed database

# Quick workflows
make dev        # Setup and start server
make quick-test # Run lint and tests
```

### Manual Commands (Alternative)

```bash
# Run all tests
bundle exec rspec

# Run specific test file
bundle exec rspec spec/requests/accounts_spec.rb

# Run with coverage report
COVERAGE=true bundle exec rspec

# Code quality
bundle exec rubocop
bundle exec brakeman
bundle exec bundle-audit check --update

# Database
rails db:reset
rails db:migrate
rails db:seed
```

## 🔒 Security

### Implemented Security Measures

- **Basic Authentication** - Secure user authentication
- **Input Validation** - Comprehensive parameter validation
- **SQL Injection Protection** - ActiveRecord parameter binding
- **XSS Protection** - Rails built-in protection
- **CSRF Protection** - Enabled for all requests
- **Security Headers** - Proper HTTP security headers
- **Error Handling** - Secure error responses

### Security Tools

- **Brakeman** - Static analysis security scanner
- **Bundle Audit** - Dependency vulnerability scanner
- **RuboCop** - Code quality and security checks

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** your changes (`git commit -m 'Add amazing feature'`)
4. **Push** to the branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request

### Development Guidelines

- Write tests for all new features
- Ensure 100% test coverage
- Follow RuboCop style guidelines
- Update documentation as needed
- Add security considerations for new features

### Code Standards

- **Ruby Style Guide** - Follow community conventions
- **Rails Best Practices** - Use Rails conventions
- **Test-Driven Development** - Write tests first
- **Documentation** - Keep docs updated

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Rails Community** - For the amazing framework
- **RSpec Team** - For excellent testing tools
- **PostgreSQL Team** - For the reliable database
- **Docker Team** - For containerization tools

---

**Made with ❤️ by the Bank Accounting Team**

[![GitHub stars](https://img.shields.io/github/stars/marcelotoledo5000/bank_accounting.svg?style=social&label=Star)](https://github.com/marcelotoledo5000/bank_accounting)
[![GitHub forks](https://img.shields.io/github/forks/marcelotoledo5000/bank_accounting.svg?style=social&label=Fork)](https://github.com/marcelotoledo5000/bank_accounting)
[![GitHub issues](https://img.shields.io/github/issues/marcelotoledo5000/bank_accounting.svg)](https://github.com/marcelotoledo5000/bank_accounting/issues)
