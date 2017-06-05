require 'rails_helper'

RSpec.describe Rule, type: :model do
  describe ".matched_rules" do
    let(:hook_payload) { JSON.parse(payload_json("pull_request.json")).with_indifferent_access }
    let(:hook_event) { HookEvent::PullRequest.new(hook_payload) }
    before do
      FactoryGirl.create(:rule, query: "foo")
      FactoryGirl.create(:rule, query: "(?:foo|bar)")
      FactoryGirl.create(:rule, query: "bar")
      hook_event.hook_params[:pull_request][:title] = "This is foo."
    end

    it "returns only matched rules" do
      rules = Rule.matched_rules(hook_event)
      expect(rules.size).to eq(2)
    end
  end
end
