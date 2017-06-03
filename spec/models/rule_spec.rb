require 'rails_helper'

RSpec.describe Rule, type: :model do
  describe ".matched_rules" do
    before do
      FactoryGirl.create(:rule, pattern: "foo")
      FactoryGirl.create(:rule, pattern: "(?:foo|bar)")
      FactoryGirl.create(:rule, pattern: "bar")
    end

    it "returns only matched rules" do
      rules = Rule.matched_rules("This is foo.")
      expect(rules.size).to eq(2)
    end
  end
end
