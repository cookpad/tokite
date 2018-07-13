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
      current_user&.token
    end

    def require_login
      return if current_user
      redirect_to sign_in_path
    end

    def octokit_user_client
      @octokit_user_client ||= Octokit::Client.new(access_token: current_user_token, auto_paginate: true)
    end

    def octokit_app_client
      if !@octokit_app_client && ENV['GITHUB_APP_ID']
        private_pem = File.read(ENV['GITHUB_APP_PEM_PATH'])
        private_key = OpenSSL::PKey::RSA.new(private_pem)
        payload = {
          iat: Time.now.to_i,
          exp: Time.now.to_i + (5 * 60),
          iss: ENV['GITHUB_APP_ID']   # GitHub App's identifier
        }
        jwt = JWT.encode(payload, private_key, "RS256")
        @octokit_app_client = Octokit::Client.new(bearer_token: jwt)
      else
        @octokit_app_client
      end
    end

    def octokit_app_installations
      @octokit_app_installations ||= octokit_app_client.find_app_installations
    end

    def octokit_user_nickname
      @octokit_user_nickname ||= octokit_user_client.user.login
    end
  end
end
