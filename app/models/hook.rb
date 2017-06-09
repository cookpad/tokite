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
    return unless event.notify?
    Rule.matched_rules(event).each do |rule|
      attachment = event.slack_attachment
      attachment[:fallback] += "\n\n#{rule.slack_attachment_fallback}"
      attachment[:text] += "\n\n#{rule.slack_attachment_text}"
      additional_text = rule.additional_text

      NotifyGithubHookEventJob.perform_now(channel: rule.channel, text: event.slack_text, attachments: [attachment])
      NotifyGithubHookEventJob.perform_now(channel: rule.channel, text: additional_text, parse: "full") if additional_text.present?
    end
  end
end