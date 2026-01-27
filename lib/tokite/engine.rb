module Tokite
  class Engine < ::Rails::Engine
    isolate_namespace Tokite

    config.before_configuration do
      require "dartsass-rails"
      require "haml-rails"
      require "propshaft"
      require "slack-notifier"
    end

    initializer "tokite.config" do
      Tokite::Engine.routes.default_url_options = { protocol: "https", host: ENV.fetch("APP_HOST", "example.com") }
    end

    initializer "tokite.assets" do |app|
      if app.config.respond_to?(:assets)
        app.config.assets.paths << Engine.root.join("vendor", "stylesheets")
      end

      app.config.dartsass.builds.merge!({
        Engine.root.join("app", "assets", "stylesheets", "tokite", "application.scss") => "tokite/application.css",
      })
    end
  end
end
