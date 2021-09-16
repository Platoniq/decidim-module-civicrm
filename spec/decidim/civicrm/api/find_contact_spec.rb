# frozen_string_literal: true

require "spec_helper"

describe Decidim::Civicrm::Api::FindContact, type: :class do
  subject { described_class.new(42) }

  describe "#result" do
    before do
      stub_api_request(:find_contact)
    end

    it "returns a Hash with the result" do
      expect(subject.result).to be_a Hash
    end
  end
end
