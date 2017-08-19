require 'rails_helper'
require 'json'

RSpec.describe "Hook", type: :request do
  describe "#create" do
    let(:headers) {
      { Tokite::HooksController::GITHUB_EVENT_HEADER => event }
    }
    let(:params) {
      JSON.parse(payload_json("#{event}.json"))
    }
    let!(:rule) { FactoryGirl.create(:rule, query: query, icon_emoji: ":snail:") }

    context "with pull_request" do
      let(:event) { "pull_request" }
      let(:query) { %(event:pull_request repo:hogelog/test-repo user:hogelog title:/./ body:/./ /./ -"unmatched word") }

      it "fire hook" do
        expect_any_instance_of(Tokite::Hook).to receive(:fire!).and_call_original
        expect_any_instance_of(Tokite::NotifyGithubHookEventJob).to receive(:perform)
        post hooks_path, params: params, headers: headers
      end
    end

    context "with issues" do
      let(:event) { "issues" }
      let(:query) { %(event:issues repo:hogelog/test-repo user:hogelog title:/./ body:/./ /./ -"unmatched word") }

      it "fire hook" do
        expect_any_instance_of(Tokite::Hook).to receive(:fire!).and_call_original
        expect_any_instance_of(Tokite::NotifyGithubHookEventJob).to receive(:perform)
        post hooks_path, params: params, headers: headers
      end
    end

    context "with issue_comment" do
      let(:event) { "issue_comment" }
      let(:query) { %(event:issue_comment repo:hogelog/test-repo user:hogelog body:/./ /./ -"unmatched word") }

      it "fire hook" do
        expect_any_instance_of(Tokite::Hook).to receive(:fire!).and_call_original
        expect_any_instance_of(Tokite::NotifyGithubHookEventJob).to receive(:perform)
        post hooks_path, params: params, headers: headers
      end
    end

    context "with pull_request_review" do
      let(:event) { "pull_request_review" }
      let(:query) { %(event:pull_request_review repo:hogelog/test-repo user:hogelog review_state:commented body:/./ /./ -"unmatched word") }

      it "fire hook" do
        expect_any_instance_of(Tokite::Hook).to receive(:fire!).and_call_original
        expect_any_instance_of(Tokite::NotifyGithubHookEventJob).to receive(:perform)
        post hooks_path, params: params, headers: headers
      end
    end

    context "with duplicated rules" do
      let(:event) { "issue_comment" }
      let(:query) { %(event:issue_comment repo:hogelog/test-repo user:hogelog body:/./ /./ -"unmatched word") }
      let!(:duplicated_rule) { FactoryGirl.create(:rule, query: query, icon_emoji: ":snail:") }

      it "preserves duplicated notification" do
        expect(Tokite::NotifyGithubHookEventJob).to receive(:perform_now).once
        post hooks_path, params: params, headers: headers
      end
    end
  end
end
