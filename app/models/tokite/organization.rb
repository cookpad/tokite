module Tokite
  class Organization < ApplicationRecord
    include Tokite::HookCommons

    def self.hook!(octokit_client, github_org)
      org_name = github_org.login
      existing_hook = find_hook(octokit_client, org_name)
      if existing_hook
        octokit_client.edit_org_hook(org_name, existing_hook.id, HookCommons.config, HookCommons.options)
      else
        octokit_client.create_org_hook(org_name, HookCommons.config, HookCommons.options)
      end
      create!(name: org_name, url: github_org.html_url)
      unhook_all_under_org!(octokit_client, org_name)
    end

    def self.find_hook(octokit_client, org_name)
      octokit_client.org_hooks(org_name).find {|hook| hook.config.url == HookCommons.url }
    end

    def self.unhook_all_under_org!(octokit_client, org_name)
      Repository.all.each do |repo|
        repo.unhook!(octokit_client) if Repository.owner(repo.name) == org_name
      end
    end

    def unhook!(octokit_client)
      hook = self.class.find_hook(octokit_client, name)
      octokit_client.remove_org_hook(name, hook.id) if hook
      destroy!
    end
  end
end
