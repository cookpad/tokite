module Tokite
  class RepositoriesController < ApplicationController
    before_action :require_github_token, only: [:new, :create, :destroy]

    def index
      @repositories = Repository.all
    end

    def new
      github_repos = octokit_client.repositories.
        select{|r| r.permissions.admin }.
        delete_if(&:fork).
        delete_if(&:archived)
      @repositories = github_repos.map do |repo|
        Repository.new(name: repo.full_name, url: repo.html_url)
      end
      Repository.all.pluck(:name).each do |existing_name|
        @repositories.delete_if {|repo| repo.name == existing_name }
      end
    end

    def create
      if params[:names].nil?
        flash[:error] = "Error: No repository was selected"
      else
        github_repos = params[:names].map do |name|
          octokit_client.repository(name)
        end
        errors = github_repos.select(&:archived).map(&:full_name)
        if errors != []
          flash[:error] = %(Error: The following repositories have been archived: #{errors.join(", ")})
        else
          github_repos.each do |repo|
            Repository.hook!(octokit_client, repo)
          end
          flash[:info] = "Import repositories."
        end
      end
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
