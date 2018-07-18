module Tokite
  class OrganizationsController < ApplicationController
    before_action :require_github_token, only: [:destroy]

    def destroy
      org = Organization.find(params[:id])
      org.unhook!(octokit_client)
      flash[:info] = "Unhook organization #{org.name}"
      redirect_to repositories_path
    end

    private

    def require_github_token
      redirect_to repositories_path unless current_user_token
    end
  end
end
