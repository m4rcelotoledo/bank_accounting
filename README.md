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

* The Ruby language - version 2.6.0
* The Rails gem     - version 5.2.3
* RSpec             - version 3.8.2
* Rubocop           - version 0.68.0
* PostgreSQL        - version 10
* Docker            - version 18.09.5
* Docker Compose    - version 1.24.0

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

### API Documentation

#### Authentication

* Needs to use Basic Authentication.

The format of a WWW-Authenticate header for HTTP basic authentication is:

```code
WWW-Authenticate: Basic realm="Our Site"
```

#### Domain

[http://localhost:3000/](http://localhost:3000)
Header with: user = cpf, pass = password

#### Endpoints

##### USERS

INDEX

```code
GET: http://DOMAIN/users
"http://localhost:3000/users"
```

Response:

```code
200 Ok
```

SHOW

```code
GET: http://DOMAIN/users/:id
"http://localhost:3000/users/1"
```

Response:

```code
200 Ok
```

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

```code
201 Created
```

##### ACCOUNT

SHOW

```code
GET: http://DOMAIN/users/:user_id/accounts/:id
"http://localhost:3000/users/1/accounts/1"
```

Response:

```code
200 Ok
```

CREATE

```code
POST: http://DOMAIN/users/:user_id/accounts
"http://localhost:3000/users/1/accounts"
Param: Body, JSON(application/json)
```

```json
{
  "user_id": "1"
}
```

Response:

```code
201 Created
```

BALANCE

```code
GET: http://DOMAIN/balance
"http://localhost:3000/balance"
Param: Body, JSON(application/json)
```

```json
{
  "account": "1"
}
```

Response:

```code
200 Ok
```

##### TRANSACTIONS

SHOW

```code
GET: http://DOMAIN/users/:user_id/accounts/:account_id/transactions/:id
"http://localhost:3000/users/1/accounts/1/transactions/1"
```

Response:

```code
200 Ok
```

CREATE

```code
POST: http://DOMAIN/users/:user_id/accounts/:account_id/transactions
"http://localhost:3000/users/1/accounts/1/transactions"
Param: Body, JSON(application/json)
```

```json
{
  "user_id": 1,
  "account_id": 1,
  "kind": "credit OR debit",
  "value": 100.0
}
```

Response:

```code
201 Created
```

TRANSFER

```code
POST: http://DOMAIN/transfer
"http://localhost:3000/transfer"
Param: Body, JSON(application/json)
```

```json
{
  "user_id": 1,
  "source_account": 1,
  "destination_account": "2",
  "amount": 100.0
}
```

Response:

```code
201 Created
```

### PENDING

* Put JSON API format response
* Separate tests from services and controllers
* Fix some code smells and other issues reported by Code Climate
* Add permissions and authorizations
* Add seeds
* Improvements:
  * add deposit function
  * add bank statement by period
  * make rules to permit just owners can make transfer, get balance, etc

## Contributing

Bank Account is open source, and we are grateful for
[everyone][contributors] who have contributed so far or want to start.

[codeclimate-badge-maintainability]: https://api.codeclimate.com/v1/badges/e3c3f8ebb8aa2d5e4740/maintainability
[codeclimate-maintainability]: https://codeclimate.com/github/marcelotoledo5000/bank_accounting/maintainability

[codeclimate-badge-coverage]: https://api.codeclimate.com/v1/badges/e3c3f8ebb8aa2d5e4740/test_coverage
[codeclimate-coverage]: https://codeclimate.com/github/marcelotoledo5000/bank_accounting/test_coverage

[travis-badge]: https://travis-ci.com/marcelotoledo5000/bank_accounting.svg?branch=master
[travis]: https://travis-ci.com/marcelotoledo5000/bank_accounting
