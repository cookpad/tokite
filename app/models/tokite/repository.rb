module Tokite
  class Repository < ApplicationRecord
    def self.hook!(octokit_client, github_repo)
      repo_name = github_repo.full_name
      existing_hook = find_hook(octokit_client, repo_name)
      if existing_hook
        octokit_client.edit_hook(repo_name, existing_hook.id, "web", hook_config, hook_options)
      else
        octokit_client.create_hook(repo_name, "web", hook_config, hook_options)
      end
      create!(name: repo_name, url: github_repo.html_url)
    end

    def self.find_hook(octokit_client, repo_name)
      octokit_client.hooks(repo_name).find {|hook| hook.config.url == hooks_url }
    end

    def self.hook_config
      {
        content_type: "json",
        url: hooks_url,
      }
    end

    def self.hook_options
      {
        events: ["*"]
      }
    end

    def self.hooks_url
      Tokite::Engine.routes.url_helpers.hooks_url
    end

    def unhook!(octokit_client)
      hook = self.class.find_hook(octokit_client, name)
      octokit_client.remove_hook(name, hook.id) if hook
      destroy!
    end
  end
end
