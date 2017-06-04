require 'rails_helper'
require 'json'

RSpec.describe "Hook", type: :request do
  describe "#create" do
    let(:headers) {
      { HooksController::GITHUB_EVENT_HEADER => event }
    }
    let(:params) {
      JSON.parse(payload_json("#{event}.json"))
    }
    let!(:rule) { FactoryGirl.create(:rule, pattern: ".") }

    context "with pull_request" do
      let(:event) { "pull_request" }

      it "fire hook" do
        expect_any_instance_of(Hook).to receive(:fire!).and_call_original
        expect_any_instance_of(Hook).to receive(:notify!)
        post hooks_path, params: params, headers: headers
      end
    end

    context "with issues" do
      let(:event) { "issues" }

      it "fire hook" do
        expect_any_instance_of(Hook).to receive(:fire!).and_call_original
        expect_any_instance_of(Hook).to receive(:notify!)
        post hooks_path, params: params, headers: headers
      end
    end

    context "with issue_comment" do
      let(:event) { "issue_comment" }

      it "fire hook" do
        expect_any_instance_of(Hook).to receive(:fire!).and_call_original
        expect_any_instance_of(Hook).to receive(:notify!)
        post hooks_path, params: params, headers: headers
      end
    end
  end
end
