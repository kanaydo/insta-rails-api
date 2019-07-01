## Insta rails REST API

a RESTful rails API for [Flutter Insta](https://github.com/kanaydo/flutter-insta).

This project is using Rails 5.2, Ruby 2.5.1 and PostgreSQL as database

## Usage
Make sure you have installed Ruby 2.5.1
```
https://github.com/kanaydo/insta-rails-api.git
cd insta-geram-api
bundle install
```

Rename file /config/database_template.yml to /config/database.yml
```
rake db:create
rake db:migrate
```
