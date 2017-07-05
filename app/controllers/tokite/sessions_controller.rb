module Tokite
  class SessionsController < ApplicationController
    skip_before_action :require_login
  
    def new
    end
  
    def create
      auth = request.env["omniauth.auth"]
      user = User.find_or_initialize_by(
        provider: auth[:provider],
        uid: auth[:uid],
      )
      unless user.persisted?
        user.update!(
          name: auth[:info][:name],
          image_url: auth[:info][:image],
        )
      end

      session[:user_id] = user.id
      redirect_to root_path
    end
  
    def destroy
      session[:user_id] = nil
      redirect_to root_path
    end
  end
end
