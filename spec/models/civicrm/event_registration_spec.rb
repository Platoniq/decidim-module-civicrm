# frozen_string_literal: true

require "spec_helper"

module Decidim::Civicrm
  describe EventRegistration do
    subject { described_class.new(meeting_registration: registration, event_meeting: event) }

    let(:event) { create :civicrm_event_meeting, meeting: meeting, organization: meeting.organization }
    let(:registration) { create :registration, meeting: meeting }
    let(:meeting) { create :meeting }

    it { is_expected.to be_valid }

    context "when no registration" do
      let(:registration) { nil }

      it { is_expected.to be_valid }
    end

    context "when no event" do
      let(:event) { nil }
      let(:registration) { create :registration }

      it { is_expected.to be_invalid }
    end

    context "when event registration is in a different event" do
      let(:registration) { create :registration }

      it { is_expected.to be_invalid }
    end
  end
end
