class UsersController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :authenticate_user!, only: [:setMenu]
  
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end
  
  private
  
  def setMenu
    @usersMenu = true
  end
end
