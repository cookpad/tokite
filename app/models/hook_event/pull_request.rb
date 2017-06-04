module HookEvent
  class PullRequest < BaseEvent
    def target_texts
      [
        hook_params[:pull_request][:title],
        hook_params[:pull_request][:body],
        hook_params[:pull_request][:user][:login],
      ]
    end
  end
end
