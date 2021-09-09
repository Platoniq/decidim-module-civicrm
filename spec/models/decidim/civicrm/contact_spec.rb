# frozen_string_literal: true

require "spec_helper"

module Decidim::Civicrm
  describe Contact do
    subject { described_class.new(civicrm_contact_id: 1) }

    it { is_expected.to be_valid }
  end
end
