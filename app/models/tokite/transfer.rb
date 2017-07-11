module Tokite
  class Transfer
    include ActiveModel::Model

    attr_accessor :rule_id, :user_id
    attr_reader :rule

    def self.create!(attributes)
      transfer = new(attributes)
      transfer.rule.update!(user_id: transfer.user_id)

      return transfer
    end

    def rule
      @rule ||= Rule.find(rule_id)
    end
  end
end
