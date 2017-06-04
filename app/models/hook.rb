class Hook
  attr_reader :event

  HOOK_EVENTS = {
    "pull_request" => HookEvent::PullRequest,
    "issues" => HookEvent::Issues,
    "issue_comment" => HookEvent::IssueComment,
  }.freeze

  def self.fire!(github_event, hook_params)
    event_class = HOOK_EVENTS[github_event]
    Hook.new(event_class.new(hook_params)).fire! if event_class
  end

  def initialize(event)
    @event = event
  end

  def fire!
    Rule.matched_rules(*event.target_texts).each do |rule|
      notify!(rule.channel)
    end
  end

  def notify!(channel)
    # TODO: Notify slack channels
  end
end