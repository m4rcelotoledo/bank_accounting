# bank_accounting 0.0.13 (Jul 28, 2025)

## 🚀 Major Improvements

### Authentication System Overhaul
* **JWT Authentication** - Replaced Basic HTTP authentication with JWT tokens
* **Token Security** - Implemented secure JWT tokens with 24-hour expiration
* **Centralized Error Handling** - Enhanced ExceptionHandler with JWT-specific error responses
* **Authentication Endpoints** - Added `/auth/login`, `/auth/logout`, and `/auth/me` endpoints
* **Token Validation** - Robust token validation with proper error handling

### Security Enhancements
* **JWT Service** - Created dedicated JwtService for token management
* **Token Expiration** - Automatic token expiration after 24 hours
* **Secure Token Generation** - Tokens signed with Rails secret key using HS256 algorithm
* **Error Centralization** - All authentication errors now centralized in ExceptionHandler
* **Input Validation** - Enhanced parameter validation for authentication endpoints

### Code Quality & Standards
* **100% Test Coverage** - Maintained complete line coverage with new JWT functionality
* **English Documentation** - All tests and comments translated to English
* **RuboCop Compliance** - Maintained all style violations and naming conventions
* **Test Organization** - Comprehensive test coverage for JWT authentication
* **Error Response Standardization** - Consistent error response format across all endpoints

### Architecture Enhancements
* **Service Layer** - Added JwtService for token management
* **Controller Separation** - New AuthController for authentication endpoints
* **Route Organization** - Clean separation of authentication routes
* **Middleware Integration** - Seamless JWT integration with existing authentication flow

### Documentation & Developer Experience
* **JWT Documentation** - Comprehensive documentation for JWT authentication
* **API Examples** - Updated all API examples to use JWT authentication
* **Authentication Guide** - Detailed guide for JWT token usage
* **Migration Guide** - Clear instructions for migrating from Basic Auth to JWT

### Testing & Quality Assurance
* **JWT Test Coverage** - Complete test coverage for JWT service and authentication endpoints
* **Error Scenario Testing** - Comprehensive testing of authentication error scenarios
* **Token Validation Testing** - Thorough testing of token generation and validation
* **Integration Testing** - End-to-end testing of JWT authentication flow

## 🔧 Technical Details

### New Features
* JWT token-based authentication system
* Token generation with user information and expiration
* Secure token validation and error handling
* Authentication endpoints for login, logout, and user info
* Centralized error handling for authentication failures

### Fixed Issues
* Replaced insecure Basic HTTP authentication
* Centralized authentication error responses
* Improved security with token-based authentication
* Enhanced error handling for invalid or missing tokens
* Standardized authentication error messages

### Breaking Changes
* **Authentication Method** - Changed from Basic HTTP authentication to JWT tokens
* **API Headers** - Now requires `Authorization: Bearer <token>` instead of Basic auth
* **Error Responses** - Updated error response format for authentication failures

### Migration Guide
* Users must now login via `/auth/login` to obtain JWT tokens
* All API requests must include `Authorization: Bearer <token>` header
* Tokens expire after 24 hours and require re-authentication

*Marcelo Toledo*

---

## bank_accounting 0.0.12 (Jul 28, 2025)

## 🚀 Major Improvements

### Code Quality & Standards
* **100% Test Coverage** - Achieved complete line coverage (193/193 lines)
* **RuboCop Compliance** - Fixed all style violations and naming conventions
* **Code Refactoring** - Improved method naming with predicate methods (ending with `?`)
* **Test Optimization** - Removed 5 duplicate test scenarios while maintaining coverage
* **Documentation** - Translated all comments to English for international standards
* **Security Hardening** - Fixed mass assignment vulnerabilities in controllers using strong parameters

### Architecture Enhancements
* **Validation Centralization** - Improved `Validations` concern with proper predicate methods
* **Error Handling** - Enhanced `ExceptionHandler` concern for better error management
* **Controller Cleanup** - Refactored controllers for better separation of concerns
* **Service Layer** - Maintained clean service architecture for business logic

### Security & Performance
* **Security Headers** - Implemented proper HTTP security headers
* **Input Validation** - Enhanced parameter validation across all endpoints
* **Error Responses** - Standardized error response format
* **Database Optimization** - Improved query performance and transaction handling

### Documentation & Developer Experience
* **README Overhaul** - Complete redesign with professional structure and comprehensive documentation
* **API Documentation** - Enhanced endpoint documentation with examples
* **Development Guidelines** - Added clear contribution guidelines and code standards
* **Tech Stack Updates** - Updated all dependency versions to latest stable releases
* **Makefile Integration** - Replaced shell scripts with comprehensive Makefile for better cross-platform compatibility

### Testing & Quality Assurance
* **Test Consolidation** - Removed duplicate test scenarios for better maintainability
* **Coverage Monitoring** - Maintained strict 100% line coverage requirement
* **Test Organization** - Improved test structure and readability
* **CI/CD Integration** - Enhanced GitHub Actions workflow

### Dependencies & Infrastructure
* **Ruby 3.4.5** - Updated to latest stable Ruby version
* **Rails 8.0.2** - Upgraded to Rails 8 with all security patches
* **PostgreSQL 15** - Updated database to latest version
* **Docker 24.0.0** - Updated containerization tools
* **Security Tools** - Integrated Brakeman and Bundle Audit for security scanning

## 🔧 Technical Details

### Fixed Issues
* Resolved RuboCop `Naming/PredicateMethod` violations
* Fixed method naming conventions in controllers
* Removed duplicate test scenarios
* Standardized error handling across the application
* Improved code organization and maintainability

### New Features
* Enhanced API documentation with comprehensive examples
* Improved error response format
* Better validation error messages
* Professional README with badges and architecture diagrams
* Comprehensive Makefile replacing shell scripts for better developer experience

### Breaking Changes
* None - All changes are backward compatible

*Marcelo Toledo*

---

# bank_accounting 0.0.11 (Feb 12, 2022)

* Security updates
* Bump a lot of gems
* Remove travis-ci
* Remove CodeClimate
* Add GitHub Actions

  *Marcelo Toledo*

## bank_accounting 0.0.10 (Jul 26, 2020)

* Security updates
* Update a lot of gems
* Update Rubocop
* Bump rack from 2.2.2 to 2.2.3
* Bump websocket-extensions from 0.1.4 to 0.1.5
* Bump kaminari from 1.2.0 to 1.2.1
* Bump puma from 4.3.3 to 4.3.5

  *Marcelo Toledo*

## bank_accounting 0.0.9 (Mai 03, 2020)

* Updated Ruby version
* Added `codecov` and `dotenv-rails` gems
* Updated some gems
* Added some badges to README.md
* Security updates

  *Marcelo Toledo*

## bank_accounting 0.0.8 (Mar 18, 2020)

* Added validation to minimum size to password required
* Updated simplecov config

  *Marcelo Toledo*

## bank_accounting 0.0.7 (Mar 17, 2020)

* Updated ruby version
* Updated a lot gems
* Updated rubocop config
* Updated travis config
* Updated docker-compose
* Routes refactored
* Controllers refactored
* TransactionService refactored
* AccountService refactored
* Get balance refactored
* Added deposit
* Added statement
* Added serializer
* Renamed transactions field: `value` to `amount`
* Updated routes
* Updated README.md

## bank_accounting 0.0.6 (Mai 25, 2019)

* Update README.md

  *Marcelo Toledo*

## bank_accounting 0.0.5 (Mai 06, 2019)

* Fixed some specs
* TDD: Added new validations to transactions
* Refactored many files
* TDD: Added Transfer

  *Marcelo Toledo*

## bank_accounting 0.0.4 (Mai 05, 2019)

* TDD: Added tests to Transaction Model
* Added Format Helper
* TDD: Set initial balance to new accounts
* TDD: User can get current balance

  *Marcelo Toledo*

## bank_accounting 0.0.3 (Mai 03, 2019)

* TDD: Added tests to Accounts Model
* Added Basic Auth
* TDD: Updated old tests to use Basic Auth in the project

  *Marcelo Toledo*

## bank_accounting 0.0.2 (Mai 02, 2019)

* Configured some gems
* TDD: Added tests to Users Model

  *Marcelo Toledo*

## bank_accounting 0.0.1 (Apr 30, 2019)

* Created project
* Configured project
* Added docker
* Added script/ to use with docker
* Added CodeClimate config
* Added Travis-CI config
* Configured Postgres Database

  *Marcelo Toledo*
