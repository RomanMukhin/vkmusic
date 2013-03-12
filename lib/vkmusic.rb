class Vkmusic
  def self.omniauth token, vk_id
    User.vk_obj(token).users.get(uid: vk_id, fields: [:screen_name, :photo]).first 
  end
end