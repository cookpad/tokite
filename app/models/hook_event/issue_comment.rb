module HookEvent
  class IssueComment < BaseEvent
    def target_texts
      [
        hook_params[:comment][:body],
        hook_params[:comment][:user][:login],
      ]
    end
  end
end
