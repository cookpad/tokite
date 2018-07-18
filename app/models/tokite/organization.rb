module Tokite
  class Organization < ApplicationRecord
    def self.hook!(octokit_client, github_org)
      org_name = github_org.login
      existing_hook = find_hook(octokit_client, org_name)
      if existing_hook
        octokit_client.edit_org_hook(org_name, existing_hook.id, hook_config, hook_options)
      else
        octokit_client.create_org_hook(org_name, hook_config, hook_options)
      end
      create!(name: org_name, url: github_org.html_url)
    end

    def self.find_hook(octokit_client, org_name)
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

    def unhook!(octokit_client)
      hook = self.class.find_hook(octokit_client, name)
      octokit_client.remove_org_hook(name, hook.id) if hook
      destroy!
    end
  end
end
