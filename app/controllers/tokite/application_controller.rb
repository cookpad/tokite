module Tokite
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
  
    helper_method :current_user
  
    before_action :require_login
  
    private
  
    def current_user
      @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    end
  
    def require_login
      return if current_user
      redirect_to sign_in_path
    end
  end
end
