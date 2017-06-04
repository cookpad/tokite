module HookEvent
  class BaseEvent
    attr_reader :hook_params

    def initialize(hook_params)
      @hook_params = hook_params
    end
  end
end
