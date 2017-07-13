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
        user.assign_attributes(
          name: auth[:info][:name],
          image_url: auth[:info][:image],
        )
        User.transaction do
          user.save!
        end
      end

      session[:user_id] = user.id
      session[:token] = auth[:credentials][:token]
      redirect_to root_path
    end
  
    def destroy
      session[:user_id] = nil
      redirect_to root_path
    end
  end
end
