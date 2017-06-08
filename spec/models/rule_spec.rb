require 'rails_helper'

RSpec.describe Rule, type: :model do
  let(:hook_payload) { JSON.parse(payload_json("pull_request.json")).with_indifferent_access }
  let(:hook_event) { HookEvent::PullRequest.new(hook_payload) }
  describe ".matched_rules" do
    before do
      FactoryGirl.create(:rule, query: "foo")
      FactoryGirl.create(:rule, query: "(?:foo|bar)")
      FactoryGirl.create(:rule, query: "/(?:foo|bar)/")
      FactoryGirl.create(:rule, query: "bar")
      hook_event.hook_params[:pull_request][:title] = "This is foo."
    end

    it "returns only matched rules" do
      rules = Rule.matched_rules(hook_event)
      expect(rules.size).to eq(2)
    end
  end

  describe "#match?" do
    let(:title) { "title" }
    let(:body) { "body" }
    let(:user_login) { "hogelog" }
    let(:rule) { FactoryGirl.create(:rule, query: query) }
    subject { rule.match?(hook_event) }
    before do
      hook_event.hook_params[:pull_request][:title] = title
      hook_event.hook_params[:pull_request][:body] = body
      hook_event.hook_params[:pull_request][:user][:login] = user_login
    end

    context "with matched single word" do
      let(:query) { "title" }
      it { is_expected.to eq(true) }
    end

    context "with unmatched single word" do
      let(:query) { "foobar" }
      it { is_expected.to eq(false) }
    end

    context "with matched multiple words" do
      let(:query) { "title body hogelog" }
      it { is_expected.to eq(true) }
    end

    context "with unmatched multiple words" do
      let(:query) { "title body hogelog foobar" }
      it { is_expected.to eq(false) }
    end

    context "with matched labeled word" do
      let(:query) { "title:title body:body user:hogelog" }
      it { is_expected.to eq(true) }
    end

    context "with unmatched labeled word" do
      let(:query) { "title:body" }
      it { is_expected.to eq(false) }
    end

    context "with matched quoted word" do
      let(:query) { %("title title") }
      before do
        hook_event.hook_params[:pull_request][:title] = %(title title)
      end
      it { is_expected.to eq(true) }
    end

    context "with unmatched quoted word" do
      let(:query) { %("title title") }
      it { is_expected.to eq(false) }
    end
  end
end
