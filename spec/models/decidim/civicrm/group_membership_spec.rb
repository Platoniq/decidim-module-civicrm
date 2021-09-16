# frozen_string_literal: true

require "spec_helper"

module Decidim::Civicrm
  describe GroupMembership do
    subject { described_class.new(organization: organization, group: group, contact: contact) }

    let!(:organization) { create(:organization) }
    let!(:group) { create(:decidim_civicrm_group) }
    let!(:contact) { create(:decidim_civicrm_contact) }

    it { is_expected.to be_valid }

    context "when contact and group are already taken" do
      context "when they belong to the same organization" do
        let!(:group_membership) { create(:decidim_civicrm_group_membership, organization: organization, contact: contact, group: group) }

        it { is_expected.not_to be_valid }
      end

      context "when they belong to another organization" do
        let!(:group_membership) { create(:decidim_civicrm_group_membership, contact: contact, group: group) }

        it { is_expected.not_to be_valid }
      end
    end
  end
end
