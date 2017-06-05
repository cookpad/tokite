Rails.application.config.slack_notifier = Slack::Notifier.new ENV["SLACK_WEBHOOK_URL"] do
  defaults username: ENV.fetch("SLACK_NAME", "tokite"),
           icon_emoji: ":sunglasses:"
end
