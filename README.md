# Bank Account

[![Maintainability][codeclimate-badge-maintainability]][codeclimate-maintainability]
[![Test Coverage][codeclimate-badge-coverage]][codeclimate-coverage]
[![Build Status][travis-badge]][travis]

## About this project

This project is a simple banking accounting system where the client has an
account and can make transfers to other accounts or can also ask the current
balance of his account.

Is a Rails application (API-only) to management Users, Accounts, and Transactions.

## Technical Informations and dependencies

* The Ruby language - version 2.7.0
* The Rails gem     - version 6.0.2
* RSpec Rails       - version 4.0.0.rc1
* Rubocop           - version 0.80.1
* PostgreSQL        - version 10
* Docker            - version 19.03.7-ce
* Docker Compose    - version 1.25.4

## To use

Clone the project:

``` Shell
git clone git@github.com:marcelotoledo5000/bank_accounting.git
cd bank_accounting
```

### With Docker (better option)

``` Shell
script/setup    # => development bootstrap, preparing containers
script/server   # => starts server
script/console  # => starts console
script/test     # => running tests
```

#### Running without Docker (not recommended!)

If you prefer, you'll need to update `config/database.yml`:

``` Yaml
# host: db        # when using docker
host: localhost   # when using localhost
```

System dependencies:

* Install and configure the database: [Postgresql-10](https://www.postgresql.org/download/)

And then:

``` Shell
gem install bundler         # => install the last Bundler version
bundle install              # => install the project's gems
rails db:setup db:migrate   # => prepare the database
rails s                     # => starts server
rails c                     # => starts console
bundle exec rspec           # => to running tests
```

### To run app

To see the application in action, starts the rails server to able [http://localhost:3000/](http://localhost:3000.)

### Dockerfile

[Dockerfile is here](https://github.com/marcelotoledo5000/Dockerfiles)

### API Documentation

#### Authentication

* Needs to use Basic Authentication: CPF and Password (minimum length: 8).

The format of a WWW-Authenticate header for HTTP basic authentication is:

```code
WWW-Authenticate: Basic realm="Our Site"
```

#### Domain

[http://localhost:3000/](http://localhost:3000)

Headers with:

user_cpf, password
"Content-Type": "application/json"

#### Endpoints

##### USERS

CREATE

```code
POST: http://DOMAIN/users
"http://localhost:3000/users"
Param: Body, JSON(application/json)
```

```json
{
  "cpf": "12345678901",
  "name": "Vladimir Harkonnen",
  "password": "password"
}
```

Response:

```json
{
    "id": 1,
    "cpf": "12345678901",
    "name": "Vladimir Harkonnen",
    "password_digest": "$2a$12$4QpARHRIf06/8kVPiPMwtel2xNQ3NpGFWf5bXb7bXIe9Wmp4uWHRe",
    "created_at": "2020-03-18T00:43:04.074Z",
    "updated_at": "2020-03-18T00:43:04.074Z"
}
```

```code
status: 201 Created
```

INDEX

```code
GET: http://DOMAIN/users
"http://localhost:3000/users"
```

Response:

```json
{
    "id": 1,
    "cpf": "12345678901",
    "name": "Vladimir Harkonnen",
    "password_digest": "$2a$12$4QpARHRIf06/8kVPiPMwtel2xNQ3NpGFWf5bXb7bXIe9Wmp4uWHRe",
    "created_at": "2020-03-18T00:43:04.074Z",
    "updated_at": "2020-03-18T00:43:04.074Z"
}
```

```code
status: 200 Ok
```

SHOW

```code
GET: http://DOMAIN/users/:id
"http://localhost:3000/users/1"
```

Response:

```json
{
    "id": 1,
    "cpf": "12345678901",
    "name": "Vladimir Harkonnen",
    "password_digest": "$2a$12$4QpARHRIf06/8kVPiPMwtel2xNQ3NpGFWf5bXb7bXIe9Wmp4uWHRe",
    "created_at": "2020-03-18T00:43:04.074Z",
    "updated_at": "2020-03-18T00:43:04.074Z"
}
```

```code
status: 200 Ok
```

##### ACCOUNTS

CREATE

```code
POST: http://DOMAIN/accounts
"http://localhost:3000/accounts"
Param: Body, JSON(application/json)
```

```json
{
  "user_id": "1"
}
```

Response:

```json
{
    "id": 1,
    "user_id": 1,
    "created_at": "2020-03-18T00:05:12.547Z",
    "updated_at": "2020-03-18T00:05:12.547Z"
}
```

```code
status: 201 Created
```

SHOW

```code
GET: http://DOMAIN/accounts/:id
"http://localhost:3000/accounts/1"
```

Response:

```json
{
    "id": 1,
    "user_id": 1,
    "created_at": "2020-03-18T00:05:12.547Z",
    "updated_at": "2020-03-18T00:05:12.547Z"
}
```

```code
status: 200 Ok
```

BALANCE

```code
GET: http://DOMAIN/balance
"http://localhost:3000/balance"
Param: Body, JSON(application/json)
```

```json
{
  "account_id": "1"
}
```

Response:

```json
450.0
```

```code
status: 200 Ok
```

STATEMENT

```code
GET: http://DOMAIN/statement
"http://localhost:3000/statement"
Param: Body, JSON(application/json)
```

```json
{
  "account_id": "1"
}
```

Response:

```json
[
    {
        "date": "2020-03-18T00:05:12.584Z",
        "document": "#1#1",
        "description": "Initial balance",
        "kind": "initial_balance",
        "amount": 0.0
    }
]
```

```code
status: 200 Ok
```

##### TRANSACTIONS

SHOW

```code
GET: http://DOMAIN/transactions/:id
"http://localhost:3000/transactions/1"
```

Response:

```json
{
    "date": "2020-03-18T00:05:12.584Z",
    "document": "#9#9",
    "description": "Initial balance",
    "kind": "initial_balance",
    "amount": 0.0
}
```

```code
status: 200 Ok
```

DEPOSIT

```code
POST: http://DOMAIN/deposit
"http://localhost:3000/deposit"
Param: Body, JSON(application/json)
```

```json
{
  "account_id": "1",
  "amount": "450"
}
```

Response:

```json
{
    "date": "2020-03-18T00:15:40.283Z",
    "document": "#1#2",
    "description": "Deposit",
    "kind": "credit",
    "amount": 450.0
}
```

```code
status: 201 Created
```

TRANSFER

```code
POST: http://DOMAIN/transfer
"http://localhost:3000/transfer"
Param: Body, JSON(application/json)
```

```json
{
  "account_id": "1",
  "destination_account": "2",
  "amount": "150"
}
```

Response:

```json
Transfer successful
```

```code
status: 201 Created
```

### PENDING IDEAS

* Put JSON API format response
* Fix some code smells and other issues reported by Code Climate
* Add permissions and authorizations
* Add seeds [X]
* Improve seeds
* Improvements:
  * statement by period
  * make rules to permit just owners can make transfer, get balance, etc
  * add deposit function [X]
  * add bank statement [X]

## Contributing

Bank Account is open source, and we are grateful for
[everyone][contributors] who have contributed so far or want to start.

[codeclimate-badge-maintainability]: https://api.codeclimate.com/v1/badges/e3c3f8ebb8aa2d5e4740/maintainability
[codeclimate-maintainability]: https://codeclimate.com/github/marcelotoledo5000/bank_accounting/maintainability

[codeclimate-badge-coverage]: https://api.codeclimate.com/v1/badges/e3c3f8ebb8aa2d5e4740/test_coverage
[codeclimate-coverage]: https://codeclimate.com/github/marcelotoledo5000/bank_accounting/test_coverage

[travis-badge]: https://travis-ci.com/marcelotoledo5000/bank_accounting.svg?branch=master
[travis]: https://travis-ci.com/marcelotoledo5000/bank_accounting
