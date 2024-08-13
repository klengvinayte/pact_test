# README

## Requirements

- Ruby 3.3.3
- Rails 7.1.3
- PostgreSQL
- Docker and Docker Compose

## Getting Started

1. Clone the repository

```bash
git clone git@github.com:klengvinayte/pact_test.git
```


```bash
docker-compose up --build
docker-compose run web rails db:migrate
```

## Running the tests

```bash
docker-compose run web rspec
```