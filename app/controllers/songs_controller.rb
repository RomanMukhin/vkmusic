class SongsController < ApplicationController
  include ApplicationHelper

  before_filter :find_song, only: [:download, :destroy]
  before_filter :find_list, except: :create
  
  def create
    @list = List.find session[:current_list]
    @list.songs.create(params[:song])
    @list = ListDecorator.decorate(@list)
  end
  
  def sort  
    @songs = @list.songs
    
    @songs.each do |song|
      song.position = params['song'].index(song.id.to_s) + 1
      song.save
    end

    render :nothing => true
  end

  def download  
    resp = download_audio(@song.url)
    @song = SongDecorator.decorate(@song)
    temp_file_sending(@song.short_name, resp)
  end

  def destroy
    #@user = User.find_by_uid session[:current_user].to_s
    @song.destroy
    #@songs = @list.songs.all
  end

  protected
  def find_song
    @song = Song.find(params[:id])
  end

  def find_list
    @list = ListDecorator.find(session[:current_list])
  end
end
