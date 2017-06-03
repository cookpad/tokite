require 'rails_helper'

RSpec.describe "Hook", type: :request do
  describe "#create" do
    let(:event) { "pull_request" }
    let(:headers) {
      { HooksController::GITHUB_EVENT_HEADER => event }
    }
    let(:params) {
      { action: "opened", number: 2, pull_request: {}, repository: {}, sender: {} }
    }

    it "fires hook event" do
      expect(Hook::PullRequest).to receive(:fire!)
      post hooks_path, params: params, headers: headers
    end
  end
end
