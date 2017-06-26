if ENV["SLACK_WEBHOOK_URL"]
  Tokite::Engine.config.slack_notifier = Slack::Notifier.new ENV["SLACK_WEBHOOK_URL"] do
    if ENV["SLACK_ICON_EMOJI"]
      defaults username: ENV.fetch("SLACK_NAME", "tokite"), icon_emoji: ENV["SLACK_ICON_EMOJI"]
    else
      defaults username: ENV.fetch("SLACK_NAME", "tokite")
    end
  end
end
