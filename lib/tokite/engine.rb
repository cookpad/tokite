module Tokite
  class Engine < ::Rails::Engine
    isolate_namespace Tokite

    config.before_configuration do
      require "haml-rails"
      require "slack-notifier"
    end

    initializer "tokite.config" do
      Tokite::Engine.routes.default_url_options = { protocol: "https", host: ENV.fetch("APP_HOST", "example.com") }
    end
  end
end
