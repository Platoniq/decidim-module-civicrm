# frozen_string_literal: true

require "spec_helper"

describe Decidim::Civicrm::Api::FindUser, type: :class do
  subject { described_class.new(42) }

  describe "#result" do
    it "returns a Hash with the result" do
      stub_user_valid_request
      
      expect(subject.result).to be_a Hash
    end
  end
end
