require 'rails_helper'

RSpec.describe Tokite::Rule, type: :model do
  let(:hook_payload) { JSON.parse(payload_json("pull_request.json")).with_indifferent_access }
  let(:hook_event) { Tokite::HookEvent::PullRequest.new(hook_payload) }

  describe ".matched_rules" do
    before do
      FactoryGirl.create(:rule, query: "foo")
      FactoryGirl.create(:rule, query: "(?:foo|bar)")
      FactoryGirl.create(:rule, query: "/(?:foo|bar)/")
      FactoryGirl.create(:rule, query: "bar")
      hook_event.hook_params[:pull_request][:title] = "This is foo."
    end

    it "returns only matched rules" do
      rules = Tokite::Rule.matched_rules(hook_event)
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
      let(:query) { "title body" }
      it { is_expected.to eq(true) }
    end

    context "with unmatched multiple words" do
      let(:query) { "title body foobar" }
      it { is_expected.to eq(false) }
    end

    context "with unlabeled word" do
      let(:query) { "hogelog" }
      it { is_expected.not_to eq(true) }
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

    context "with case unmatched word" do
      let(:query) { "TITLE" }
      it { is_expected.to eq(true) }
    end

    context "with case unmatched regular expression" do
      let(:query) { '/\ATITLE\z/' }
      it { is_expected.to eq(true) }
    end

    context "with backslash regular expression" do
      let(:query) { 'body:/\AThis is \w+.\z/' }
      let(:body) { "This is body." }
      it { is_expected.to eq(true) }
    end
  end

  describe "validates :query" do
    let(:query) { "foo bar" }
    let(:rule) { FactoryGirl.build(:rule, query: query) }

    it { expect(rule).to be_valid }

    context "with unclosed quoted text" do
      let(:query) { 'foobar "foo bar' }

      it { expect(rule).not_to be_valid }
    end

    context "with unclosed regular expression" do
      let(:query) { 'foobar /foo bar' }

      it { expect(rule).not_to be_valid }
    end
  end
end
