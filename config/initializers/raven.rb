if ENV["SENTRY_DSN"]
  require "raven"
  require "raven/transports/fluentd"

  Raven.configure do |config|
    config.dsn = ENV["SENTRY_DSN"]
  end
end
