class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  #unless :devise_controller?
    before_action :setMenu
  #end
  
  private
  
  def setMenu
    @homeMenu = true
  end
end
