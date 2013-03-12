class MainController < ApplicationController
  include ApplicationHelper
  
  def index
    @user = Vkmusic.omniauth(session[:token], session[:vk_id])
    User.authorization(@user.screen_name, @user.uid, session[:token])
    session[:current_user] = @user.uid.to_s
    
    @user_vkontakte = User.find_by_uid(@user.uid.to_s)
    @lists = @user_vkontakte.lists
    search_my_music
    unless @user_vkontakte.lists.all.first.nil? 
      @list = ListDecorator.find(session[:current_list] ||= @user_vkontakte.lists.all.first.id)
    end
    @audios = Kaminari.paginate_array(@audios).page(params[:page]).per(20)
    @user = UserDecorator.decorate(@user)
  end 

  def search
    @audios = User.vk_obj(session[:token]).audio.search(q: params[:search])
    @audios = SongDecorator.decorate_collection(@audios)
    @audios = Kaminari.paginate_array(@audios).page(params[:page]).per(20)
  end

  def search_my_music
    @audios = User.vk_obj(session[:token]).audio.get
    @audios = SongDecorator.decorate_collection(@audios)
  end
 
  def download
    resp = download_audio(params[:url])
    temp_file_sending(song_name(params[:name],params[:url]), resp)
  end
end
