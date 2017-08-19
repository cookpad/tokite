if ENV["SLACK_WEBHOOK_URL"]
  webhook_url = ENV["SLACK_WEBHOOK_URL"]
elsif Rails.env.test?
  webhook_url = "https://example.com/notify"
end

if webhook_url
  Tokite::Engine.config.slack_notifier = Slack::Notifier.new webhook_url do
    if ENV["SLACK_ICON_EMOJI"]
      defaults username: ENV.fetch("SLACK_NAME", "tokite"), icon_emoji: ENV["SLACK_ICON_EMOJI"]
    else
      defaults username: ENV.fetch("SLACK_NAME", "tokite")
    end
  end
end
