module Tokite
  class SessionsController < ApplicationController
    skip_before_action :require_login
  
    def new
    end
  
    def create
      auth = request.env["omniauth.auth"]
      user = User.login!(auth)
      session[:user_id] = user.id
      redirect_to root_path
    end
  
    def destroy
      session[:user_id] = nil
      redirect_to root_path
    end
  end
end
