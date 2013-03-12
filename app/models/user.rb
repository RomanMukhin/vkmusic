class User < ActiveRecord::Base
  attr_accessible :name, :uid, :token
  has_many :lists, dependent: :destroy
  validates :uid, presence: true

  def self.authorization screen_name, uid, token
    unless User.find_by_uid(uid.to_s)
      User.create!(name: screen_name, uid: uid.to_s, token: token) 
    else
      user = User.find_by_uid(uid.to_s)
      user.token = token
      user.save
    end
  end

  def self.vk_obj session
    VkontakteApi::Client.new(session)
  end
  
  def self.current_tab(user_vkontakte, session)
    unless user_vkontakte.lists.all.first.nil? 
      session ||= user_vkontakte.lists.all.first.id
      list_tab = ListDecorator.decorate(List.find_by_id session)
    end
  end

  def self.refresh_audio_url
    token = User.last.token
	  song = Song.last
	  lists = List.all
	  unless !Song.all.empty? && song.url == vk_obj(token).audio.search(q: "#{song.artist} #{song.title}")[1].url
	    lists.each do |list|
	      list.songs.each do |song|
	    	  unless vk_obj(token).audio.search(q: "#{song.artist} #{song.title}")[0] == 0
		        song.url = vk_obj(token).audio.search(q: "#{song.artist} #{song.title}")[1].url
	        	song.save 
		      end
	      end
	    end
    end
  end
end
