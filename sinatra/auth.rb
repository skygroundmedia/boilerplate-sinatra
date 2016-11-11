#Every Sinatra extension must have this
require 'sinatra/base'
#Display messages when a user logs in/out
require 'sinatra/flash'

#Standard extensions are modules within a Sinatra module
module Sinatra
  module Auth
    #Arbitrarily titled "Helpers"
    module Helpers
      #Check session to see if user has logged in
      #Use this method to route views and handlers
      def authorized?
        session[:admin] 
      end
      #Ensure that only an authorized user can log-in
      def protected!
        #Check authorized method, before halting
        halt 401, slim(:unauthorized) unless authorized?
      end
    end
    #This method introduces the settings including route handlers
    #This method hooks up the Helpers
    #app object means the application using this extension
    def self.registered(app)
      app.helpers Helpers
      
      app.enable :sessions
      #These settings can be overriden in main app.rb
      app.set :username => 'temp_user',
              :password => 'temp_pass'
      # ##################
      # Routes
      # ########
      app.get '/login' do
        slim :login
      end

      app.post '/login' do
        if params[:username] == settings.username && params[:password] == settings.password
          session[:admin] = true
          flash[:notice] = "You are now logged in as #{settings.username}"
          redirect to('/songs')
        else
          flash[:notice] = "The username or password you entered are incorrect"
          redirect to('/login')
        end
      end

      app.get '/logout' do
        session[:admin] = nil
        flash[:notice] = "You have now logged out"
        redirect to('/')
      end
    end
  end
  register Auth
end