# frozen_string_literal: true

require "spec_helper"

module Decidim::Civicrm
  describe EventMeeting do
    subject { described_class.new(organization: organization, meeting: meeting, redirect_url: url, redirect_active: active, civicrm_event_id: event_id) }

    let!(:meeting) { create :meeting }
    let(:organization) { meeting.organization }
    let(:url) { ::Faker::Internet.url }
    let(:active) { true }
    let(:event_id) { 1234 }

    it { is_expected.to be_valid }

    context "when no organization" do
      let(:organization) { nil }

      it { is_expected.to be_invalid }
    end

    context "when no event_id" do
      let(:event_id) { nil }

      it { is_expected.to be_valid }

      context "and there's no redirect_url" do
        let(:url) { nil }

        it { is_expected.to be_invalid }
      end
    end

    context "when no meeting" do
      let(:meeting) { nil }
      let(:organization) { create :organization }

      it { is_expected.to be_invalid }
    end

    context "when meeting organization is different than organization" do
      let(:organization) { create :organization }

      it { is_expected.to be_invalid }
    end
  end
end
