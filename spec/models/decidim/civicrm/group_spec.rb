# frozen_string_literal: true

require "spec_helper"

module Decidim::Civicrm
  describe Group do
    let!(:organization) { create(:organization) }

    subject { described_class.new(organization: organization, civicrm_group_id: 1, title: "Group") }

    it { is_expected.to be_valid }
  end
end
