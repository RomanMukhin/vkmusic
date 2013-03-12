# encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  
  rescue_from Faraday::Error::TimeoutError, :with => :redirected 
  
  rescue_from CanCan::AccessDenied, :with => :redirected

  rescue_from Faraday::Error::ConnectionFailed, :with => :redirected 

  #check_authorization


  def current_user
    User.find_by_uid(session[:current_user])
  end

  helper_method :logged_in?
  
  def logged_in?
    session[:token].present?
  end

  private 
  def redirected
    session[:token] = nil
    flash[:error] = "You don't have access to this section."
    redirect_to root_path
  end
end
