Rails.application.config.slack_notifier = Slack::Notifier.new ENV["SLACK_WEBHOOK_URL"] do
  defaults channel: ENV.fetch("SLACK_DEFAULT_CHANNEL", "#general"),
           username: ENV.fetch("SLACK_NAME", "tokite"),
           icon_emoji: ":sunglasses:"
end
