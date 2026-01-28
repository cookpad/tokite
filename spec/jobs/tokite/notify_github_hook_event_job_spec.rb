require 'rails_helper'

RSpec.describe Tokite::NotifyGithubHookEventJob, type: :job do
  describe "#perform" do
    let(:slack_notifier) { instance_double(Slack::Notifier) }
    let(:payload) { "Example payload" }

    before do
      allow(Rails.application.config).to receive(:slack_notifier).and_return(slack_notifier)
    end

    it "invokes Slack notifier with the given payload" do
      expect(slack_notifier).to receive(:ping).with(payload)

      described_class.new.perform(payload)
    end
  end
end
