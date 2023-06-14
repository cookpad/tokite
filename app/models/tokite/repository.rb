module Tokite
  class Repository < ApplicationRecord
    include Tokite::HookCommons

    def self.hook!(octokit_client, github_repo)
      repo_name = github_repo.full_name
      existing_hook = find_hook(octokit_client, repo_name)
      if existing_hook
        octokit_client.edit_hook(repo_name, existing_hook.id, "web", HookCommons.config, HookCommons.options)
      else
        octokit_client.create_hook(repo_name, "web", HookCommons.config, HookCommons.options)
      end
      create!(name: repo_name, url: github_repo.html_url)
    end

    def self.find_hook(octokit_client, repo_name)
      octokit_client.hooks(repo_name).find {|hook| hook.config.url == HookCommons.url }
    end

    def self.owner(repo)
      repo.split('/')[0]
    end

    def unhook!(octokit_client)
      hook = self.class.find_hook(octokit_client, name)
      octokit_client.remove_hook(name, hook.id) if hook
      destroy!
    end
  end
end
