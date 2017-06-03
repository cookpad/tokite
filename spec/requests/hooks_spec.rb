require 'rails_helper'
require 'json'

RSpec.describe "Hook", type: :request do
  describe "#create" do
    let(:event) { "pull_request" }
    let(:headers) {
      { HooksController::GITHUB_EVENT_HEADER => event }
    }
    let(:params) {
      JSON.parse(payload_json("pull_request.json"))
    }

    it "fires hook_event event" do
      expect_any_instance_of(Hook).to receive(:fire!).and_call_original
      post hooks_path, params: params, headers: headers
    end
  end
end
