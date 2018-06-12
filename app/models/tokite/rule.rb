module Tokite
  class Rule < ApplicationRecord
    attr_reader :search_query

    belongs_to :user

    validates :name, presence: true
    validate :validate_query
    validate :validate_user_id
    validate :validate_channel

    before_validation :normalize_channel

    INVALID_CHANNEL_CHARS = [" ", ","]

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
      "<#{Tokite::Engine.routes.url_helpers.edit_rule_url(self)}|#{name}>"
    end

    def user_link
      "<#{Tokite::Engine.routes.url_helpers.user_url(user)}|#{user.name}>"
    end

    private

    def validate_query
      SearchQuery.parse(query)
    rescue SearchQuery::ParseError => e
      errors.add(:query, e.message)
    end

    def validate_user_id
      unless User.find_by(id: user_id)
        errors.add(:user_id, "Unknown user_id: #{user_id}")
      end
    end

    def validate_channel
      INVALID_CHANNEL_CHARS.each do |invalid_char|
        errors.add(:channel, %(Invalid character: "#{invalid_char}")) if channel.index(invalid_char)
      end
    end

    def normalize_channel
      if channel.start_with?("#")
        self.channel = channel.strip
      else
        self.channel = "##{channel.strip}"
      end
    end
  end
end
