module HookEvent
  class BaseEvent
    attr_reader :hook_params

    def initialize(hook_params)
      @hook_params = hook_params
    end

    def slack_payload(rule)
      {
        channel: rule.channel,
        text: slack_text,
        attachments: slack_attachments(rule),
      }
    end
  end
end
