# README

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

# Deploying to Heroku
Deploying a git repository to Heroku.
## 1. Install Heroku CLI
- You can find instructions [here](https://devcenter.heroku.com/articles/heroku-cli#download-and-install)
## 2. Create a Heroku remote
- You need a remote repository on Heroku if you do not have one already.
    ```
    $ heroku create
    Creating app... done, ⬢ thawing-inlet-61413
    https://thawing-inlet-61413.herokuapp.com/ | https://git.heroku.com/thawing-inlet-61413.git
    ```
## 3. Deploying the code
- Use ```git push``` to push the code to Heroku.
    ```
    $ git push heroku main
    Initializing repository, done.
    updating 'refs/heads/main'
    ...
    ```
More detailed documentation for deploying using Heroku CLI can be found [here](https://devcenter.heroku.com/articles/git#prerequisites-install-git-and-the-heroku-cli)

# CI/CD
Continous Integration and Continous Deployment

## 1. Create main.yml file in .github/workflows path
- Our main.yml file can be located in the .github/workflows path in this repository with everything set up.
- More Details on how to create a custom github action can be found [here](https://dev.to/codefund/ci-for-ruby-on-rails-github-actions-3mn1)
- First, to make sure the functionality if the website is working properly, the environment has to be initialized
- To do this, we setup ruby, node, and yarn dependacies in the actrion. We also set up the postgresql database
- After this, we use rake db:create db:migrate and db:seed to setup our database correctly for the Rails site to work properly.
- Next an important components when creating the action is to run the rspec test located in the spec directory
- Running these test ensures that all functionality of the site is working properly when changes to the repository have been made.
- Once the build and testing phases have passed, github will show that the newly update reposirty was built properly.

## 2. Adding continous integration with Heroku
- Once our CI workflow has been set up, we are ready to add continous deployment for our app. It can also be found at the end of this section.                                                                  
- More in detail information can be found [here.](https://devcenter.heroku.com/articles/github-integration) 
- First you will need a heroku app create on your heroku dashboard.
- Now you can go to inside your app and navigate to the "Deploy" section.
- Here, you are able to connect you github repository directly to heroku.
- After connecting your repository, you can enable Automatic Deployment with a click of a bit under the section where you connected your github repo.
- You are also given the option to check a box to only deploy when all CI has passed. This prevent the deployment of failing github build from being deployed.
- Repo's current CI action: ```main.yml``` 
    ```
    name: Continuous Integration
    on: [push, pull_request]
    jobs:
    build:
        runs-on: ubuntu-latest
        
        services:
        db:
            image: postgres:11
            ports: ["5432:5432"]
            env:
            POSTGRES_USER: postgres
            POSTGRES_PASSWORD: password
            options: >-
            --health-cmd pg_isready
            --health-interval 10s
            --health-timeout 5s
            --health-retries 5
        redis:
            image: redis
            ports: ["6379:6379"]
            options: --entrypoint redis-server

        steps:
        - name: Checkout code
        uses: actions/checkout@v2

        - name: Setup Ruby and install gems
        uses: ruby/setup-ruby@v1
        with:
            bundler-cache: true
            ruby-version: 2.7.2

        - name: Setup Node
        uses: actions/setup-node@v1
        with:
            node-version: 10.19.0

        - name: Find yarn cache location
        id: yarn-cache
        run: echo "::set-output name=dir::$(yarn cache dir)"
        - name: JS package cache
        uses: actions/cache@v1
        with:
            path: ${{ steps.yarn-cache.outputs.dir }}
            key: ${{ runner.os }}-yarn-${{ hashFiles('**/yarn.lock') }}
            restore-keys: |
            ${{ runner.os }}-yarn-
        - name: Install packages
        run: |
            yarn install --pure-lockfile

        - name: Build
        env:
            DATABASE_URL: postgres://postgres:@localhost:5432/test
            REDIS_URL: redis://localhost:6379/0
            RAILS_ENV: test
            POSTGRES_USER: postgres
            POSTGRES_PASSWORD: password
        run: | 
            sudo apt-get -yqq install libpq-dev
            bundle exec rake db:create
            bundle exec rake db:migrate
            bundle exec rake db:seed

    test:
        runs-on: ubuntu-latest
        
        services:
        db:
            image: postgres:11
            ports: ["5432:5432"]
            env:
            POSTGRES_USER: postgres
            POSTGRES_PASSWORD: password
            options: >-
            --health-cmd pg_isready
            --health-interval 10s
            --health-timeout 5s
            --health-retries 5
        redis:
            image: redis
            ports: ["6379:6379"]
            options: --entrypoint redis-server

        steps:
        - name: Checkout code
        uses: actions/checkout@v2

        - name: Setup Ruby and install gems
        uses: ruby/setup-ruby@v1
        with:
            bundler-cache: true
            ruby-version: 2.7.2

        - name: Setup Node
        uses: actions/setup-node@v1
        with:
            node-version: 10.19.0

        - name: Find yarn cache location
        id: yarn-cache
        run: echo "::set-output name=dir::$(yarn cache dir)"
        - name: JS package cache
        uses: actions/cache@v1
        with:
            path: ${{ steps.yarn-cache.outputs.dir }}
            key: ${{ runner.os }}-yarn-${{ hashFiles('**/yarn.lock') }}
            restore-keys: |
            ${{ runner.os }}-yarn-
        - name: Install packages
        run: |
            yarn install --pure-lockfile

        - name: Build and Test
        env:
            DATABASE_URL: postgres://postgres:@localhost:5432/test
            REDIS_URL: redis://localhost:6379/0
            RAILS_ENV: test
            POSTGRES_USER: postgres
            POSTGRES_PASSWORD: password
        run: | 
            sudo apt-get -yqq install libpq-dev
            bundle exec rake db:create
            bundle exec rake db:migrate
            bundle exec rake db:seed
            bundle exec rspec spec/ -fd

    ```




