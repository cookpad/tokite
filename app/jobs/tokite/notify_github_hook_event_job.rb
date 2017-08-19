require "tokite/exception_logger"

module Tokite
  class NotifyGithubHookEventJob < ApplicationJob
    queue_as :default
  
    def perform(payload)
      Rails.application.config.slack_notifier.ping(payload)
    rescue Slack::Notifier::APIError => e
      ExceptionLogger.log(e)
    end
  end
end
