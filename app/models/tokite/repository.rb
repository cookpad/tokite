module Tokite
  class Repository < ApplicationRecord
    def self.hook_repo!(octokit_client, github_repo)
      repo_name = github_repo.full_name
      existing_hook = find_repo_hook(octokit_client, repo_name)
      if existing_hook
        octokit_client.edit_hook(repo_name, existing_hook.id, "web", hook_config, hook_options)
      else
        octokit_client.create_hook(repo_name, "web", hook_config, hook_options)
      end
      create!(name: repo_name, url: github_repo.html_url)
    end

    def self.hook_org!(octokit_client, github_org)
      org_name = github_org.login
      existing_hook = find_org_hook(octokit_client, org_name)
      if existing_hook
        octokit_client.edit_org_hook(org_name, existing_hook.id, hook_config, hook_options)
      else
        octokit_client.create_org_hook(org_name, hook_config, hook_options)
      end
      unhook_all_repos_under!(octokit_client, org_name)
      create!(name: org_name, url: github_org.html_url, is_org: true)
    end

    def self.unhook_all_repos_under(octokit_client, org_name)
      Repository.all.each do |repo|
        repo.unhook_repo!(octokit_client) if !repo.is_org && owner(repo.name) == org_name
      end
    end

    def self.find_repo_hook(octokit_client, repo_name)
      octokit_client.hooks(repo_name).find {|hook| hook.config.url == hooks_url }
    end

    def self.find_org_hook(octokit_client, org_name)
      octokit_client.org_hooks(org_name).find {|hook| hook.config.url == hooks_url }
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

    def self.owner(repo)
      repo.split('/')[0]
    end

    def unhook!(octokit_client)
      if is_org
        unhook_org!(octokit_client)
      else
        unhook_repo!(octokit_client)
      end
    end

    def unhook_repo!(octokit_client)
      hook = self.class.find_repo_hook(octokit_client, name)
      octokit_client.remove_hook(name, hook.id) if hook
      destroy!
    end

    def unhook_org!(octokit_client)
      hook = self.class.find_org_hook(octokit_client, name)
      octokit_client.remove_org_hook(name, hook.id) if hook
      destroy!
    end
  end
end
