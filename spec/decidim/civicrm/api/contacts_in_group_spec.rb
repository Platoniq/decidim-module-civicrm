# frozen_string_literal: true

require "spec_helper"

describe Decidim::Civicrm::Api::ContactsInGroup, type: :class do
  subject { described_class.new(1) }

  describe "#result" do
    it "returns a Hash with the result" do
      stub_contacts_in_group_valid_request

      expect(subject.result).to be_a Hash
    end
  end
end
