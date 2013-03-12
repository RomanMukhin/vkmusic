class MainController < ApplicationController
  include ApplicationHelper
  
  def index
    @user = Vkmusic.omniauth(session[:token], session[:vk_id])
    User.authorization(@user.screen_name, @user.uid, session[:token])
    session[:current_user] = @user.uid.to_s
    
    if @user_vkontakte = User.find_by_uid(@user.uid.to_s)
      @lists = @user_vkontakte.lists
      search_my_music
      unless @user_vkontakte.lists.all.first.nil? 
        @list = ListDecorator.find(session[:current_list] ||= @user_vkontakte.lists.all.first.id)
      end
      @audios = Kaminari.paginate_array(@audios).page(params[:page]).per(20)
      @user = UserDecorator.decorate(@user)
    else
      render_404
    end
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

  protected
  def render_404
    respond_to do |format|
      format.html { render :file => "#{Rails.root}/public/404.html", :status => :not_found, :layout => false}
      format.xml  { head :not_found }
      format.any  { head :not_found }
    end
  end
end