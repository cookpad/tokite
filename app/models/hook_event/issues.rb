module HookEvent
  class Issues
    attr_reader :issue

    def initialize(hook_params)
      @issue = hook_params[:issue]
    end

    def target_texts
      [
        comment[:title],
        comment[:body],
        comment[:user][:login],
      ]
    end
  end
end
