# frozen_string_literal: true

module Tokite
  class HooksController < ActionController::API
    GITHUB_EVENT_HEADER = "X-GitHub-Event"

    def create
      logger.debug("Hook triggered: #{github_event}")
      unless request.request_parameters["repository"]["private"]
        Hook.fire!(github_event, request.request_parameters)
      end
      render plain: "ok"
    end

    private

    def github_event
      request.headers[GITHUB_EVENT_HEADER]
    end
  end
end
