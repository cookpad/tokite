# frozen_string_literal: true

module Tokite
  class HooksController < ActionController::API
    GITHUB_EVENT_HEADER = "X-GitHub-Event"
  
    def create
      Hook.fire!(github_event, request.request_parameters)
      render plain: "ok"
    end
  
    private
  
    def github_event
      request.headers[GITHUB_EVENT_HEADER]
    end
  end
end
