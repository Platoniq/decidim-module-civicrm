# frozen_string_literal: true

require "spec_helper"

module Decidim::Civicrm
  describe GroupMembership do
    let!(:organization) { create(:organization) }    
    let!(:group) { create(:decidim_civicrm_group) }
    let!(:contact) { create(:decidim_civicrm_contact) }

    subject { described_class.new(organization: organization, group: group, contact: contact) }

    it { is_expected.to be_valid }
  end
end
