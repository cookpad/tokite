module Tokite
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
  
    helper_method :current_user, :current_user_token

    before_action :require_login
  
    private
  
    def current_user
      @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    end

    def current_user_token
      session[:token]
    end

    def require_login
      return if current_user
      redirect_to sign_in_path
    end

    def octokit_client
      @octokit_client ||= Octokit::Client.new(access_token: current_user_token, auto_paginate: true)
    end
  end
end
