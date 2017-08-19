module Tokite
  class Hook
    attr_reader :event
  
    HOOK_EVENTS = {
      "pull_request" => HookEvent::PullRequest,
      "issues" => HookEvent::Issues,
      "issue_comment" => HookEvent::IssueComment,
      "pull_request_review" => HookEvent::PullRequestReview,
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
      payloads = []
      Rule.matched_rules(event).each do |rule|
        attachment = event.slack_attachment
        attachment[:fallback] += "\n\n#{rule.slack_attachment_fallback}"
        attachment[:text] += "\n\n#{rule.slack_attachment_text}"
        emoji = rule.icon_emoji.chomp.presence
        additional_text = rule.additional_text

        if payloads.none? {|payload| payload[:channel] == rule.channel && payload[:emoji] == emoji && payload[:additional_text] == additional_text }
          payloads << {
            channel: rule.channel,
            text: event.slack_text,
            emoji: emoji,
            additional_text: additional_text,
            attachments: [attachment],
          }
        end
      end
      payloads.each do |payload|
        notify!(channel: payload[:channel], text: payload[:text], icon_emoji: payload[:emoji], attachments: payload[:attachments])
        notify!(channel: payload[:channel], text: payload[:additional_text], icon_emoji: payload[:emoji], parse: "full") if payload[:additional_text].present?
      end
    end
  
    def notify!(payload)
      NotifyGithubHookEventJob.perform_now(payload.compact)
    end
  end
end
