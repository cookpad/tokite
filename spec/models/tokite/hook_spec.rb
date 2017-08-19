require 'rails_helper'

RSpec.describe Tokite::Hook, type: :model do
  xdescribe "fire!" do
    context "for debug" do
      before do
        FactoryGirl.create(:rule, query: "/./", channel: "#test-private", additional_text: "@hogelog Hi!")
      end
      let(:params) {
        JSON.parse(payload_json("#{event}.json")).with_indifferent_access
      }

      context "with issue comment" do
        let(:event) { "issue_comment" }
        it { Tokite::Hook.fire!(event, params) }
      end

      context "with issues" do
        let(:event) { "issues" }
        it { Tokite::Hook.fire!(event, params) }
      end

      context "with pull request" do
        let(:event) { "pull_request" }
        it { Tokite::Hook.fire!(event, params) }
      end

      context "with pull request review" do
        let(:event) { "pull_request_review" }
        it { Tokite::Hook.fire!(event, params) }
      end
    end
  end
end
