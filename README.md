Requirements
-------------

- ruby 2.1.0p0
- Rails 4.0.4
- PostgreSQL 9.1.13

Getting Started
-------------
There a couple of things you need to do before Chat will work on your machine. Assuming you already have a working Ruby environment and Bundler installed, you can go to the repository chaaat https://github.com/SBS-team/chaaat and clone it in your terminal:

    git clone https://github.com/SBS-team/chaaat.git

- Change directory to chaaat and install the gems from 'Gemfile':
```
    cd chaaat
    bundle install
```

- Chaaat is configured to use Pusher. To get this working locally, you need to register your app with Pusher and add some Pusher credentials in '.env' file. For example:
```
    Pusher.app_id = 'your-pusher-app-id'
    Pusher.key = 'your-pusher-key'
    Pusher.secret = 'your-pusher-secret'
    Pusher.host   = '192.168.137.75'
    Pusher.port   = 4567
```
- Or you can use Slanger. You need to install Slanger Server
```
    gem install slanger
```
and add Slanger credentials:
```
    slanger --app_key 765ec374ae0a69f4ce44 --secret your-pusher-secret
```
- Chaaat uses gem OmniAuth for login from Facebook and Github. Add some OmniAuth credentials in '.env' file. For example:
```
    provider :github, 'GITHUB_KEY', 'GITHUB_SECRET'
    provider :facebook, 'FACEBOOK_KEY', 'FACEBOOK_SECRET'
```
- Add 'config/database.yml' file.

- Create database:
```
    rake db:create
```
    
- Run the database migration:
```
    rake db:migrate
``` 
- Start the web server:
```
    rails s
```

- Using a browser, go to http://localhost:3000, login and start chatting.

Database
--------

This application uses PostgreSQL with ActiveRecord.

Development
-----------

-   Template Engine: Haml
-   Testing Framework: RSpec and Factory Girl
-   Front-end Framework: Bootstrap 3.0 (Sass)
-   Authentication: Devise


Email
-----

The application is configured to send email using a Gmail account. Add credentials in '.env' file. Example you can get from '.env.example' file.


License
-------

Copyright (c) 2014 FaceIT, Inc.
