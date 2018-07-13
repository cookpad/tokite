module Tokite
  class RepositoriesController < ApplicationController
    before_action :require_github_token, only: [:new, :create, :destroy]

    def index
      if ENV["GITHUB_APP_ID"]
        @installation_url = Pathname(ENV['GITHUB_APP_URL']).join('installations/new').to_s
        @user_repos = []
        @orgs = []
        all_insts = octokit_app_client.find_app_installations
        user_name = octokit_user_client.user.login

        all_insts.each do |inst|
          if inst.account.login == user_name
            res = octokit_user_client.find_installation_repositories_for_user(inst.id)
            @user_repos << {name: res.repositories[0].full_name, url: res.repositories[0].html_url}
          end
        end

        user_orgs_dict = {}
        octokit_user_client.find_user_installations.installations.each do |inst|
          user_orgs_dict[inst.account.login] = true if inst.account.type == "Organization"
        end
        all_org_insts = all_insts.select do |inst| inst.account.type == "Organization" end
        all_org_insts.each do |inst|
          @orgs << {
            name: inst.account.login,
            limited: inst.repository_selection == "selected",
            url: inst.account.html_url,
            admin_url: user_orgs_dict[inst.account.login] ? inst.html_url : nil
          }
        end
      else
        @repositories = Repository.all
      end
    end

    def new
      github_repos = octokit_user_client.repositories.
        select{|r| r.permissions.admin }.
        delete_if(&:fork).
        delete_if(&:archived)
      @repositories = github_repos.map do |repo|
        Repository.new(name: repo.full_name, url: repo.html_url, private: repo.private)
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
          octokit_user_client.repository(name)
        end
        errors = github_repos.select(&:archived).map(&:full_name)
        if errors != []
          flash[:error] = %(Error: The following repositories have been archived: #{errors.join(", ")})
        else
          github_repos.each do |repo|
            Repository.hook!(octokit_user_client, repo)
          end
          flash[:info] = "Import repositories."
        end
      end
      redirect_to repositories_path
    end

    def destroy
      repo = Repository.find(params[:id])
      repo.unhook!(octokit_user_client)
      flash[:info] = "Unhook repository #{repo.name}"
      redirect_to repositories_path
    end

    private

    def require_github_token
      redirect_to repositories_path unless current_user_token
    end
  end
end
