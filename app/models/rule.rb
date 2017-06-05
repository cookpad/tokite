class Rule < ApplicationRecord
  belongs_to :user

  # TODO: Performance
  def self.matched_rules(*texts)
    Rule.all.to_a.select do |rule|
      texts.any?{|text| text.match(rule.query) }
    end
  end

  def slack_attachment
    {
      fallback: "#{name} by #{user.name}",
      text: "<#{Rails.application.routes.url_helpers.root_url}|Rule #{name} by #{user.name}>",
      color: "#439FE0"
    }
  end
end