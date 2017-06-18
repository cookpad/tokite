module Tokite
  class NotifyGithubHookEventJob < ApplicationJob
    queue_as :default
  
    def perform(payload)
      Rails.application.config.slack_notifier.ping(payload)
    end
  end
end
