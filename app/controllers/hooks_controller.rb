# frozen_string_literal: true

class HooksController < ActionController::Base
  protect_from_forgery with: :null_session

  GITHUB_EVENT_HEADER = "X-GitHub-Event"

  def create
    Hook.fire!(github_event, hook_params)
    render plain: "ok"
  end

  private

  def github_event
    request.headers[GITHUB_EVENT_HEADER]
  end

  def hook_params
    params.permit(:action, :number, :repository, :sender, :issue_comment)
  end
end