require 'rails_helper'

RSpec.describe Hook, type: :model do
  describe "fire!" do
    xcontext "for debug" do
      before do
        FactoryGirl.create(:rule, pattern: ".", channel: "#test-private")
      end
      let(:params) {
        JSON.parse(payload_json("#{event}.json")).with_indifferent_access
      }

      context "with issue comment" do
        let(:event) { "issue_comment" }
        it { Hook.fire!(event, params) }
      end

      context "with issues" do
        let(:event) { "issues" }
        it { Hook.fire!(event, params) }
      end

      context "with pull request" do
        let(:event) { "pull_request" }
        it { Hook.fire!(event, params) }
      end
    end
  end
end
