# frozen_string_literal: true

require "spec_helper"

module Decidim::Civicrm
  describe Contact do
    let!(:organization) { create(:organization) }
    let!(:user) { create(:user) }

    subject { described_class.new(organization: organization, user: user, civicrm_contact_id: 1) }

    it { is_expected.to be_valid }
  end
end
