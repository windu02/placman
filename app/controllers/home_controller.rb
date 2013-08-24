class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:setMenu]
  
  def index
    @users = User.all
  end
  
  private
  
  def setMenu
    @homeMenu = true
  end
end
