# frozen_string_literal: true

require "spec_helper"

module Decidim::Civicrm
  describe GroupParticipatorySpace do
    subject { described_class.new(group: group, participatory_space: space) }

    let(:organization) { create :organization }
    let(:group) { create(:civicrm_group, organization: organization) }
    let(:space) { create(:participatory_process, organization: organization) }

    it { is_expected.to be_valid }

    context "when no group" do
      let(:group) { nil }

      it { is_expected.to be_invalid }
    end

    context "when no participatory space" do
      let(:space) { nil }

      it { is_expected.to be_invalid }
    end

    context "when different organizations" do
      let(:space) { create :participatory_process }

      it { is_expected.to be_invalid }
    end
  end
end
