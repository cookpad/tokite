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
    let!(:rule) { FactoryBot.create(:rule, query: query, icon_emoji: ":snail:") }

    context "with pull_request" do
      let(:event) { "pull_request" }
      let(:query) { %(event:pull_request repo:hogelog/test-repo user:hogelog title:/./ body:/./ /./ -"unmatched word") }

      it "fires a hook" do
        expect_any_instance_of(Tokite::Hook).to receive(:fire!).and_call_original
        expect_any_instance_of(Tokite::NotifyGithubHookEventJob).to receive(:perform)
        post hooks_path, params: params, headers: headers, as: :json
      end

      context "without body comment" do
        let(:query) { %(event:pull_request user:hogelog) }
        before do
          params["pull_request"].delete("body")
        end

        it "fires a hook" do
          expect_any_instance_of(Tokite::Hook).to receive(:fire!).and_call_original
          expect_any_instance_of(Tokite::NotifyGithubHookEventJob).to receive(:perform)
          post hooks_path, params: params, headers: headers, as: :json
        end
      end
    end

    context "with issues" do
      let(:event) { "issues" }
      let(:query) { %(event:issues repo:hogelog/test-repo user:hogelog title:/./ body:/./ /./ -"unmatched word") }

      it "fires a hook" do
        expect_any_instance_of(Tokite::Hook).to receive(:fire!).and_call_original
        expect_any_instance_of(Tokite::NotifyGithubHookEventJob).to receive(:perform)
        post hooks_path, params: params, headers: headers, as: :json
      end

      context "without body comment" do
        let(:query) { %(event:issues user:hogelog) }
        before do 
          params["issue"].delete("body")
        end

        it "fires a hook" do
          expect_any_instance_of(Tokite::Hook).to receive(:fire!).and_call_original
          expect_any_instance_of(Tokite::NotifyGithubHookEventJob).to receive(:perform)
          post hooks_path, params: params, headers: headers, as: :json
        end
      end
    end

    context "with issue_comment" do
      let(:event) { "issue_comment" }
      let(:query) { %(event:issue_comment repo:hogelog/test-repo user:hogelog body:/./ /./ -"unmatched word") }

      it "fires a hook" do
        expect_any_instance_of(Tokite::Hook).to receive(:fire!).and_call_original
        expect_any_instance_of(Tokite::NotifyGithubHookEventJob).to receive(:perform)
        post hooks_path, params: params, headers: headers, as: :json
      end
    end

    context "with pull_request_review" do
      let(:event) { "pull_request_review" }
      let(:query) { %(event:pull_request_review repo:hogelog/test-repo user:hogelog review_state:commented body:/./ /./ -"unmatched word") }

      it "fires a hook" do
        expect_any_instance_of(Tokite::Hook).to receive(:fire!).and_call_original
        expect_any_instance_of(Tokite::NotifyGithubHookEventJob).to receive(:perform)
        post hooks_path, params: params, headers: headers, as: :json
      end

      context "without body comment" do 
        let(:query) { %(event:pull_request_review user:hogelog) }
        before do 
          params["review"].delete("body")
        end

        it "fires a hook" do
          expect_any_instance_of(Tokite::Hook).to receive(:fire!).and_call_original
          expect_any_instance_of(Tokite::NotifyGithubHookEventJob).not_to receive(:perform)
          post hooks_path, params: params, headers: headers, as: :json
        end
      end
    end

    context "with pull_request_review_comment" do
      let(:event) { "pull_request_review_comment" }
      let(:query) { %(event:pull_request_review_comment repo:hogelog/test-repo user:hogelog body:/./ /./ -"unmatched word") }

      it "fires a hook" do
        expect_any_instance_of(Tokite::Hook).to receive(:fire!).and_call_original
        expect_any_instance_of(Tokite::NotifyGithubHookEventJob).to receive(:perform)
        post hooks_path, params: params, headers: headers, as: :json
      end
    end

    context "with duplicated rules" do
      let(:event) { "issue_comment" }
      let(:query) { %(event:issue_comment repo:hogelog/test-repo user:hogelog body:/./ /./ -"unmatched word") }
      let!(:duplicated_rule) { FactoryBot.create(:rule, query: query, icon_emoji: ":snail:") }

      it "preserves duplicated notification" do
        expect(Tokite::NotifyGithubHookEventJob).to receive(:perform_now).once
        post hooks_path, params: params, headers: headers, as: :json
      end
    end

    context "when slack returns error" do
      let(:event) { "pull_request" }
      let(:query) { %(event:pull_request repo:hogelog/test-repo user:hogelog title:/./ body:/./ /./ -"unmatched word") }

      it "captures exception" do
        expect_any_instance_of(Tokite::Hook).to receive(:fire!).and_call_original
        expect_any_instance_of(Slack::Notifier).to receive(:ping).and_raise(Slack::Notifier::APIError)
        expect(Tokite::ExceptionLogger).to receive(:log).once
        post hooks_path, params: params, headers: headers, as: :json
      end
    end

    context "with label rule" do
      let(:event) { "issues" }
      let(:query) { %(label:/bug|foobar/) }

      it "fires a hook" do
        expect_any_instance_of(Tokite::Hook).to receive(:fire!).and_call_original
        expect_any_instance_of(Tokite::NotifyGithubHookEventJob).to receive(:perform)
        post hooks_path, params: params, headers: headers, as: :json
      end
    end

    context "with unmatched label rule" do
      let(:event) { "issues" }
      let(:query) { %(label:/foo|bar/) }

      it "doesn't notify to slack" do
        expect_any_instance_of(Tokite::Hook).to receive(:fire!).and_call_original
        expect_any_instance_of(Tokite::NotifyGithubHookEventJob).not_to receive(:perform)
        post hooks_path, params: params, headers: headers, as: :json
      end
    end

    context "with requested_reviewer rule" do
      let(:event) { "pull_request" }
      let(:query) { %(requested_reviewer:other_user) }

      it "fires a hook" do
        expect_any_instance_of(Tokite::Hook).to receive(:fire!).and_call_original
        expect_any_instance_of(Tokite::NotifyGithubHookEventJob).to receive(:perform)
        post hooks_path, params: params, headers: headers, as: :json
      end
    end

    context "with requested_team rule" do
      let(:event) { "pull_request" }
      let(:query) { %(requested_team:github/justice-league) }

      it "fires a hook" do
        expect_any_instance_of(Tokite::Hook).to receive(:fire!).and_call_original
        expect_any_instance_of(Tokite::NotifyGithubHookEventJob).to receive(:perform)
        post hooks_path, params: params, headers: headers, as: :json
      end
    end
  end
end
