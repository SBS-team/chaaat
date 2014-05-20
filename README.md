Build Status:
[![Build Status](https://travis-ci.org/SBS-team/chaaat.svg?branch=pedalki)](https://travis-ci.org/SBS-team/chaaat)
[![Code Climate](https://codeclimate.com/repos/5375f4216956800d6d009602/badges/fe68f6232634377e2b5e/gpa.png)](https://codeclimate.com/repos/5375f4216956800d6d009602/feed)
[![Coverage Status](https://coveralls.io/repos/SBS-team/chaaat/badge.png)](https://coveralls.io/r/SBS-team/chaaat)
Site Description
----------------
Chaat is an open-source application which creates for real-time commnication with your partners, friends e.t.c. This app executes in HipChat style and has such functionality as:
- creating chat rooms where you have an opportunity to сommunicte with a group of people you add
- chating with person privately
- adding your friends  through email invitation without any limits
- attaching files (documents, images, viedos from youtube)
- every user has his own profile which he can customize



Requirements
-------------

- ruby 2.1.0p0
- Rails 4.0.4
- PostgreSQL 9.1.13

Getting Started
-------------
There is a couple things you need to start working with Chaaat on your machine. If  you have been already worked with Ruby environment and has Bundler been installed, you can go to the repository "chaaat" https://github.com/SBS-team/chaaat and clone it via your terminal:

    git clone https://github.com/SBS-team/chaaat.git

- Then change directory to chaaat and install the gems from 'Gemfile':
```
    cd chaaat
    bundle install
```

- Chaaat is configure to use Pusher. If you need to work it locally, you should to register your app using Pusher and add some Pusher credentials in '.env' file. For example:
```
    Pusher.app_id = 'your-pusher-app-id'
    Pusher.key = 'your-pusher-key'
    Pusher.secret = 'your-pusher-secret'
    Pusher.host   = 'your-host'
    Pusher.port   = 4567
```
- Also you can use Slanger. You need to install Slanger Server
```
    gem install slanger
```
- add Slanger credentials:
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

Current Staging Location
------------------------

[ruby-chat-st.loc](http://ruby-chat-st.loc/)

[ruby-chat.tk](http://www.ruby-chat.tk)


License
-------

Chaaat is made available under the [MIT License](http://www.opensource.org/licenses/mit-license.php).
