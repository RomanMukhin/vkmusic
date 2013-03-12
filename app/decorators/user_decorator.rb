class UserDecorator < Draper::Decorator
  delegate_all

  def photo
    h.image_tag(model.photo, width: 20)
  end
  def fio
    h.content_tag(:text,"#{model.first_name} #{model.last_name}")
  end

  def vk_url
    "http://vk.com/#{model.screen_name}"
  end
end
