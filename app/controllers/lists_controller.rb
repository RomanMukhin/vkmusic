class ListsController < ApplicationController
  before_filter :find_user
  
  def show
    @list = ListDecorator.find(params[:id])
    session[:current_list] = @list.id
    @lists = @user.lists.all
  end

  def create
    @list = @user.lists.create(params[:list])
    session[:current_list] = @list.id
    @lists = @user.lists.all
  end

  def destroy
    List.find(params[:id]).destroy
    @lists = @user.lists.all
    if(params[:id].to_i == session[:current_list])
      session[:current_list] = @lists.last.id unless @lists.nil?
    end
    @list = ListDecorator.find session[:current_list] unless @lists.nil?
  end

  protected
  def find_user
    @user = User.find_by_uid(session[:current_user].to_s)
  end
end
