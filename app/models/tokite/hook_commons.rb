module Tokite
  module HookCommons
    def self.config
      {
        content_type: "json",
        url: url,
      }
    end

    def self.options
      {
        events: ["*"]
      }
    end

    def self.url
      Tokite::Engine.routes.url_helpers.hooks_url
    end
  end
end
