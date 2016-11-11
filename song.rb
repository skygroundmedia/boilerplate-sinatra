require 'date'
require 'dm-core'
require 'dm-migrations'

class Song
  #2. Link the song class to the data mapper
  #This is how you make a ruby class a data mapper resource
  include DataMapper::Resource
  #3. Create your class
  #Identifier that auto-increments
  property :id,          Serial
  property :title,       String
  property :lyrics,      Text
  property :length,      Integer
  property :released_on, Date
  #Keep count of Facebook Likes
  #Remember! Use "DataMapper.auto_upgrade!" to keep Active Record working
  property :likes,       Integer, :default => 0
  
  #Convert data from :released_on to a Date object
  def released_on=date
    super DateTime.strptime(date, '%m/%d/%Y')
  end  
end


# ##################
# This checks data/table/class integrity
# ##################
DataMapper.finalize

# ##################
# Helpers
# ##################
module SongHelpers
  def find_songs
    @songs = Song.all
  end
  
  def find_song
    Song.get(params[:id])
  end
  
  def create_song
    @song = Song.create(params[:song])
  end
end
# Initialize Helpers
helpers SongHelpers

# ##################
# Routes + Controllers
# ##################
get '/songs' do
  #Show all items
  find_songs
  slim :"songs/songs"
end

get '/songs/new' do
  protected!
  @song = Song.new
  slim :"songs/new_song"
end

get '/songs/:id' do
  #Show form to view existing item
  @song = find_song
  slim :"songs/show_song"
end

get '/songs/:id/edit' do
  protected!
  @song = find_song
  slim :"songs/edit_song"
end

#Create
post '/songs' do
  protected!
  if create_song
    flash[:notice] = "Song successfully added"
  end
  redirect to("/songs/#{@song.id}")
end

#Likes
post '/songs/:id/like' do
  @song = find_song
  @song.likes = @song.likes.next
  @song.save
  #Only redirect back to the same page if the request is AJAX-triggered
  #:layout => false helps the page layout from not repeating itself
  redirect to"/songs/#{@song.id}" unless request.xhr?
  slim :"songs/like", :layout => false
end

#Update item
put '/songs/:id' do
  protected!
  song = find_song
  if song.update(params[:song])
    flash[:notice] = "Song successfully updated"
  end
  redirect to("/songs/#{song.id}")
end

delete '/songs/:id' do
  protected!
  if find_song.destroy
    flash[:notice] = "Song deleted"
  end
  redirect to('/songs')
end