module Tokite
  class RepositoriesController < ApplicationController
    before_action :require_github_token, only: [:new, :create, :destroy]

    def index
      @orgs = []
      @repositories = []
      Repository.all.each do |item|
        if item.is_org
          @orgs << item
        else
          @repositories << item
        end
      end
    end

    def new
      github_orgs = octokit_client.organization_memberships.
        select{|membership| membership.role == "admin"}.
        map{|membership| membership.organization }
      github_repos = octokit_client.repositories.
        select{|r| r.permissions.admin }.
        delete_if(&:fork).
        delete_if(&:archived)
      @orgs = github_orgs.map do |org|
        Repository.new(name: org.login, url: URI.join(ENV["GITHUB_HOST"], org.login).to_s, is_org: true)
      end
      @repositories = github_repos.map do |repo|
        Repository.new(name: repo.full_name, url: repo.html_url, private: repo.private)
      end
      Repository.all.pluck(:name).each do |existing_name|
        @orgs.delete_if {|org| org.name == existing_name }
        @repositories.
          delete_if {|repo| repo.name == existing_name }.
          delete_if {|repo| Repository.owner(repo.name) == existing_name }
      end
    end

    def create
      org_names = params[:org_names] || []
      repo_names = params[:repo_names] || []
      if repo_names.length + org_names.length == 0
        flash[:error] = "Error: No organization/repository was selected"
      else
        github_orgs = org_names.map{ |name| octokit_client.organization(name) }
        github_repos = repo_names.map{ |name| octokit_client.repository(name) }
        errors = github_repos.select(&:archived).map(&:full_name)
        if errors != []
          flash[:error] = %(Error: The following repositories have been archived: #{errors.join(", ")})
        else
          github_orgs.each{ |repo| Repository.hook_org!(octokit_client, repo) }
          github_repos.each{ |repo| Repository.hook_repo!(octokit_client, repo) }
          flash[:info] = "Import organizations/repositories."
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
