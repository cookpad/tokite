class Rule < ApplicationRecord
  belongs_to :user

  # TODO: Performance
  def self.matched_rules(*texts)
    Rule.all.to_a.select do |rule|
      texts.any?{|text| text.match(rule.pattern) }
    end
  end

  def slack_channels
    channels.split(/[\s,]/)
  end

  def notify!
  end
end