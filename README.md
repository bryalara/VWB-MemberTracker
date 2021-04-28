# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

Use "login_with_oauth" in your tests to bypass google oauth authentication! - Daniel Phan

# Quick Setup On Local Machine
This repository can be easily setup on you own server, the following instruction is based on WSL Ubuntu on Windows:
## 1. Installation and Preparation:
- Clone repository from the main or dev branch
- Install Ruby 2.7.2 and [Ruby on Rails](https://guides.rubyonrails.org/getting_started.html)
- Install [PostgresSQL](https://www.postgresql.org/download/)
- In the command line, run:
    ```
    yarn install
    bundle install
    ```
    to setup environment
- Also, run:
    ```
    rails db:drop db:create db:migrate db:seed
    ```
    to setup the database.
    
    - Change the command on demand, like no need to use "db:drop" for the first setup
    - Add yourself as natural admin in the ./db/seeds.rb
## 2. Running
- In the command line, run:
    ```
    rails server
    ```
- This will start the server
- By default, in your web browser, enter:
    ```
    http://localhost:3000/
    ```
- You should be able to load the VWB-Member Tracker in a few seconds
- For any changes you made, just reload the pages to view the changes
## 3.Testing
If you want to run testing files on local machine:

- Rspec:
    ```
    rspec ./spec
    ```
    or any sub folder of ./spec
- Rubocop:
    ```
    rubocop
    ```
- Brakeman:
    ```
    brakeman
    ```
- Simplecov: result will be automatically generated after running Rspec