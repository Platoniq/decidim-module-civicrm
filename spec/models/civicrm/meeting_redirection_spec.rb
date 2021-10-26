# frozen_string_literal: true

require "spec_helper"

module Decidim::Civicrm
  describe MeetingRedirection do
    subject { described_class.new(organization: organization, meeting: meeting, url: url, active: active) }

    let!(:meeting) { create :meeting }
    let(:organization) { meeting.organization }
    let(:url) { ::Faker::Internet.url }
    let(:active) { true }

    it { is_expected.to be_valid }

    context "when no organization" do
      let(:organization) { nil }

      it { is_expected.to be_invalid }
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
