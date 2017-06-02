class HooksController < ActionController::Base
  protect_from_forgery with: :null_session

  def create
    Hook.fire!(github_event, hook_params)
    render plain: "ok"
  end

  private

  def github_event
    request.headers["X-GitHub-Event"]
  end

  def hook_params
    params.permit(:action, :repository, :sender, :issue_comment)
  end
end