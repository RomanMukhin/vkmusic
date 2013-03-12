# encoding: utf-8
class SessionsController < ApplicationController
  def new
    srand
    session[:state] ||= Digest::MD5.hexdigest(rand.to_s)
    @vk_url = VkontakteApi.authorization_url(scope: [:offline, :audio], state: session[:state])
  end
  
  def callback
    redirect_to root_url, alert: I18n.t('alert.callback') and return if session[:state].present? && session[:state] != params[:state]
    @vk = VkontakteApi.authorize(code: params[:code])
    session[:token] = @vk.token
    session[:vk_id] = @vk.user_id
    
    redirect_to root_url
  end
  
  def destroy
    User.find_by_token(session[:token]).update_attributes(token: nil)
    session[:token] = nil
    session[:vk_id] = nil
    
    redirect_to root_url
  end
end
