module Tokite
  class Rule < ApplicationRecord
    attr_reader :search_query
  
    belongs_to :user
  
    validate :validate_query
  
    # TODO: Performance
    def self.matched_rules(event)
      Rule.all.to_a.select do |rule|
        rule.match?(event)
      end
    end
  
    def search_query
      @search_query ||= SearchQuery.new(query)
    end
  
    def match?(event)
      search_query.match?(event.fields)
    end
  
    def slack_attachment_fallback
      "#{name} by #{user.name}"
    end
  
    def slack_attachment_text
      "#{rule_name_link} (#{user_link}) "
    end
  
    def rule_name_link
      "<#{Tokite::Engine.routes.url_helpers.edit_user_rule_url(user, self)}|#{name}>"
    end
  
    def user_link
      "<#{Tokite::Engine.routes.url_helpers.user_rules_url(user)}|#{user.name}>"
    end
  
    def validate_query
      SearchQuery.parse(query)
    rescue SearchQuery::ParseError => e
      errors.add(:query, e.message)
    end
  end
end
