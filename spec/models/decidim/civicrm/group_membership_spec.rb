# frozen_string_literal: true

require "spec_helper"

module Decidim::Civicrm
  describe GroupMembership do
    subject { described_class.new(group: group, contact: contact) }

    let(:group) { create(:decidim_civicrm_group) }
    let(:contact) { create(:decidim_civicrm_contact) }

    it { is_expected.to be_valid }
  end
end
