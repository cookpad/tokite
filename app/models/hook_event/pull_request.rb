module HookEvent
  class PullRequest
    attr_reader :pull_request

    def initialize(hook_params)
      @pull_request = hook_params[:pull_request]
    end

    def target_texts
      [
        pull_request[:title],
        pull_request[:body],
        pull_request[:user][:login],
      ]
    end
  end
end
