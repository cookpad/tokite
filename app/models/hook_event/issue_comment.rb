module HookEvent
  class IssueComment
    attr_reader :comment

    def initialize(hook_params)
      @comment = hook_params[:comment]
    end

    def target_texts
      [
        comment[:body],
        comment[:user][:login],
      ]
    end
  end
end
