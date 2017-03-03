Boilerplate Sinatra
=


Boilerplate Sinatra app that includes:

- Heroku-Ready
- User Registration
- Sendmail using GMail and Sendgrid
- Warden Authentication


# Step 1

## Download this app

Install [this codebase](https://github.com/chrisjmendez/boilerplate-sinatra)


# Step 2

## Set-up your dev environment

Make sure you're using Ruby 2.2.5. If not, review this article on how to [upgrade Ruby on Mac OS X using rbenv](/2016/05/05/installing-ruby-on-rails-on-osx-using-rbenv/)

```language-powerbash
 ruby -v
```

Update gem –the package manager we're going to use.

```language-powerbash
 sudo gem update
```

Update all the app packages found in ```Gemfile```.
```language-powerbash
 sudo gem install bundler 
```


# Step 3


### Install app packages

Install all the app specific packages
```language-powerbash
 bundle install --without production
```




# Step 4

## Start local webserver

Start your web server (using [Procfile](https://devcenter.heroku.com/articles/getting-started-with-ruby#declare-process-types-with-procfile) +  [Foreman](https://github.com/ddollar/foreman) )

```language-powerbash
 gem install foreman
```

```language-powerbash
 foreman start
```


# Step 5

## Build your app



# Step 6

## Configure Heroku

Install [Heroku](http://heroku.com)
```language-powerbash
 sudo gem install heroku
```

# Log in to Heroku

```language-powerbash
 heroku login
```

If you need a local SQL database, you'll need to pick PostGres
* [PostGreSQL Local Setup](https://devcenter.heroku.com/articles/heroku-postgresql#local-setup)

## Configure Heroku Toolbelt

* [Gemfile, Procfile, Foreman, 'oh my!'](https://devcenter.heroku.com/articles/getting-started-with-ruby)



# Step 8

### Publishing from Git to Heroku

- [Deploying from GIT to Heroku](https://devcenter.heroku.com/articles/git#creating-a-heroku-remote)

### Verify the remote git 
```language-powerbash
  git remote -v 
```

### Verfify you have an app in Heroku
```language-powerbash
  heroku apps
```

### Link your git to Heroku
```language-powerbash
  heroku git:remote -a [name of app on heroku]
```


# Step 9

### Bundle and Lock down your Gemfile
```language-powerbash
  bundle install --without production
```

### Publish your git code to Heroku and Github
```language-powerbash
  git push heroku master
```

---


# Databasese


### Managing a local DB through IRB

First register your database by finding and promoting it
```language-powerbash
 irb
```

```language-powerbash
 require './app'
```

```language-powerbash
 DataMapper.auto_migrate!
```

### Managing a production DB through Heroku's Console

First register your database by finding and promoting it
```language-powerbash
  heroku pg
```

```language-powerbash
  heroku pg:promote [HEROKU_POSTGRESQL_NAME_OF_DATABASE]
```

```language-powerbash
  heroku run console
```
```language-powerbash
  require './app'
```
```language-powerbash
  DataMapper.auto_migrate!
```

---

# Installing SQLite

Use [Homebrew](http://brew.sh/) to install SQLite

```language-powerbash
  ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
```

```language-powerbash
  brew install sqlite
```

```language-powerbash
  gem install sqlite
```


---

 
# Process

1. Gemfile is used to store all the libraries and dependencies you'll need to launch and deploy your app.
2. Procfile is the process file you used to kickstart your app.
3. Foreman is the toolkit you use to automatically start-up your server
4. SQLite is what you'll use for a local SQl database
5. Postgresql is the SQL database you'll use for production
6. config.ru is the configuration file that connect Procfile to your initial app.rb file.

### Adding a new property to the Database

Add the property within the class
```language-powerbash
 property :likes, Integer, :default => 0
```

Use IRB to migrate the database
```language-powerbash
 bash$ irb
```

Use DataMapper to update the tables
```language-powerbash
 DataMapper.auto_upgrade!
```

Test out your work
```language-powerbash
 bash$ irb
```

```language-powerbash
 require './app' 
```

```language-powerbash
 bash$ song = Song.first
```

```language-powerbash
 bash$ song.likes
```

---


# Double check your DB on Heroku

### Run Console

```language-powerbash
 heroku run console
```

### Upgrade DB

```language-powerbash
 require './main'
```

```language-powerbash
 DataMapper.auto_upgrade!
```

---


# Resources

- [Github Sinatra Book Code](https://github.com/spbooks/SINATRA1)

- [Upgrading Heroku Database](https://devcenter.heroku.com/articles/upgrade-heroku-postgres-with-pgbackups)


### Authentication

- [Authentication w/ Warden](http://skli.se/2013/03/08/sinatra-warden-auth/)
- [Facebook authentication with koala](https://github.com/benben/simple-ruby-facebook-example)
- [twitter authentication](http://recipes.sinatrarb.com/p/middleware/twitter_authentication_with_omniauth)
- [Simple Facebook authentication](https://github.com/benben/simple-ruby-facebook-example)
- [Basic Sinatra Authentication](https://github.com/maxjustus/sinatra-authentication)

### Boilerplate Code

- Install a raw [Boilerplate Sinatra codebase](https://github.com/bmizerany/heroku-sinatra-app)


---


# Errors

## foreman start

Web server errors
Find out if any servers are running 'headless'
```language-powerbash
  ps aux | grep ruby
```

Quit any 'headless' running servers
```language-powerbash
  kill -9 xxxxxx
```

##Check Heroku logs

```language-powerbash
  heroku logs
```


