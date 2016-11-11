# You'll need to require these if you
# want to develop while running with ruby.
# The config/rackup.ru requires these as well
# for it's own reasons.
#
# $ ruby heroku-sinatra-app.rb
#
require 'sinatra'
require 'sinatra/flash'
require 'sinatra/reloader' if development?

require 'slim'
require 'sass'
require 'pony'
require 'v8'
require 'coffee-script'

require './song'
require './sinatra/auth'

before do
  p "#########"
  puts '[Params]', params
  p "#########"
end

configure do
  # ###############
  # Sessions
  # #######
  enable :sessions
  set :session_secret, 'THIS IS MY SECRET KEY'
  # ###############
  # Auth: Global User + Pass
  # #######  
  set :username => "admin"
  set :password => "p@ssword"
  # ###############
  # HTML Formatting Pretty
  # #######  
  set :slim, :pretty => true
end

configure :development do
  # ###############
  # Database Connector
  # #######  
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
  # ###############
  # E-mail
  # #######  
  set :email_address  => 'smtp.gmail.com',
  :email_user_name    => 'support@guitarpick.fm',
  :email_password     => 'P@ssw0rd',
  :email_domain       => 'localhost.localdomain' #'gmail.com'
  # ###############
  # Error Loggin
  # #######  
  enable :logging, :dump_errors, :raise_errors
end

configure :production do
  # ###############
  # Database Connector
  # #######  
  DataMapper.setup(:default, ENV['DATABASE_URL'])
  # ###############
  # E-mail
  # #######  
  set :email_address  => 'smtp.sendgrid.net',
  :email_user_name    => ENV['SENDGRID_USERNAME'],
  :email_password     => ENV['SENDGRID_PASSWORD'],
  :email_domain       => 'heroku.com'
end

# ##################
# Global CSS + JS
# ######
get('/css/styles.css'){ scss :styles }
get('/js/app.js'){ coffee :app }

# ##################
# Helpers 
# ######
helpers do
  def css(*stylesheets)
    stylesheets.map do |stylesheet|
      "<link href=\"/css/#{stylesheet}.css\" media='screen' rel='stylesheet' />"
    end.join
  end
  
  def current?(path='/')
    (request.path==path || request.path==path+'/') ? "current" : nil
  end
  
  def set_title
    @title ||= "Songs by Guitar Cookbook"
  end
  
  def send_message
    Pony.mail(
    :from    => params[:name] + "<" + params[:email] + ">",
    :to      => settings.email_user_name,
    :subject => params[:name] + " has contacted you",
    :body    => params[:message],
    :via     => :smtp,
    :via_options => { 
      :address              => settings.email_address, 
      :port                 => '587', 
      :enable_starttls_auto => true, 
      :user_name            => settings.email_user_name, 
      :password             => settings.email_password, 
      :authentication       => :plain, # :plain, :login, :cram_md5, no auth by default
      :domain               => settings.email_domain
    }
    )
  end
end

before do 
  set_title
end

after '/special/*' do
  
end

# ##################
# Sessions example test
# ######
get '/set/:name' do
  session[:name] = params[:name]
end

get '/get/hello' do
  "Hello #{session[:name]}"
end

# ##################
# Basic
# ######
get '/' do
  slim :home
end

get '/about' do
  slim :about
end

get '/contact' do
  slim :contact
end

not_found do
  slim :not_found
end

post '/contact' do
  send_message
  flash[:notice] = "Thank you for your message. We'll be in touch soon."
  redirect('/')
end

# Test at <appname>.heroku.com

# You can see all your app specific information this way.
# IMPORTANT! This is a very bad thing to do for a production
# application with sensitive information

# get '/env' do
#   ENV.inspect
# end
