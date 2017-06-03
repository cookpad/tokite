class Rule < ApplicationRecord
  belongs_to :user

  # TODO: Performance
  def self.matched_rules(text)
    Rule.all.to_a.select do |rule|
      text.match(rule.pattern)
    end
  end

  def slack_channels
    channels.split(/[\s,]/)
  end
end