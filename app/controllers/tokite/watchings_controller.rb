module Tokite
  class WatchingsController < ApplicationController
    before_action :require_github_token, only: [:new, :create, :destroy]

    def index
      @orgs = Organization.all
      @repositories = Repository.all
    end

    def new
      github_orgs = octokit_client.organization_memberships.
        select{|membership| membership.role == "admin"}.
        map{|membership| membership.organization }
      @orgs = github_orgs.map do |org|
        Organization.new(name: org.login, url: URI.join(ENV["GITHUB_HOST"], org.login).to_s)
      end

      github_repos = octokit_client.repositories.
        select{|r| r.permissions.admin }.
        delete_if(&:fork).
        delete_if(&:archived)
      @repositories = github_repos.map do |repo|
        Repository.new(name: repo.full_name, url: repo.html_url, private: repo.private)
      end

      Organization.all.pluck(:name).each do |existing_name|
        @orgs.delete_if {|org| org.name == existing_name }
        @repositories.delete_if {|repo| Repository.owner(repo.name) == existing_name }
      end
      Repository.all.pluck(:name).each do |existing_name|
        @repositories.delete_if {|repo| repo.name == existing_name }
      end
    end

    def create
      org_names = params[:org_names] || []
      repo_names = params[:repo_names] || []
      repo_names.delete_if do |repo_name|
        org_names.find{ |org_name| Repository.owner(repo_name) == org_name }
      end

      if repo_names.length + org_names.length == 0
        flash[:error] = "Error: No organization/repository was selected"
      else
        github_orgs = org_names.map{ |name| octokit_client.organization(name) }
        github_repos = repo_names.map{ |name| octokit_client.repository(name) }
        errors = github_repos.select(&:archived).map(&:full_name)
        if errors != []
          flash[:error] = %(Error: The following repositories have been archived: #{errors.join(", ")})
        else
          github_orgs.each{ |org| Organization.hook!(octokit_client, org) }
          github_repos.each{ |repo| Repository.hook!(octokit_client, repo) }
          flash[:info] = "Import organizations/repositories."
        end
      end
      redirect_to watchings_path
    end

    def destroy
      if params[:type] == "org"
        org = Organization.find(params[:id])
        org.unhook!(octokit_client)
        flash[:info] = "Unhook organization #{org.name}"
      else
        repo = Repository.find(params[:id])
        repo.unhook!(octokit_client)
        flash[:info] = "Unhook repository #{repo.name}"
      end
      redirect_to watchings_path
    end

    private

    def require_github_token
      redirect_to watchings_path unless current_user_token
    end
  end
end
