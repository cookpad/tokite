module Tokite
  class OrgHooksController < ActionController::API
    GITHUB_EVENT_HEADER = "X-GitHub-Event"

    def create
      logger.debug("Organization Hook triggered: #{github_event}")
      Hook.fire!(github_event, request.request_parameters)
      render plain: "ok"
    end

    private

    def github_event
      request.headers[GITHUB_EVENT_HEADER]
    end
  end
end
