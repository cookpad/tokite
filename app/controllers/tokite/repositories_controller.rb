module Tokite
  class RepositoriesController < ApplicationController
    before_action :require_github_token, only: [:new, :create, :destroy]

    def index
      @repositories = Repository.all
    end

    def new
      github_repos = octokit_client.repositories.select{|r| r.permissions.admin }.delete_if(&:fork)
      @repositories = github_repos.map do |repo|
        Repository.new(name: repo.full_name, url: repo.html_url)
      end
      Repository.all.pluck(:name).each do |existing_name|
        @repositories.delete_if {|repo| repo.name == existing_name }
      end
    end

    def create
      params[:names].each do |name|
        github_repo = octokit_client.repository(name)
        Repository.hook!(octokit_client, github_repo)
      end
      flash[:info] = "Import repositories."
      redirect_to repositories_path
    end

    def destroy
      repo = Repository.find(params[:id])
      repo.unhook!(octokit_client)
      flash[:info] = "Unhook repository #{repo.name}"
      redirect_to repositories_path
    end

    private

    def require_github_token
      redirect_to repositories_path unless current_user_token
    end
  end
end
