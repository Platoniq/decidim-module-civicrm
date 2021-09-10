# frozen_string_literal: true

require "spec_helper"

describe Decidim::Civicrm::Api::ListGroups, type: :class do
  subject { described_class.new }
  
  describe "#result" do
    it "returns a Hash with the result" do
      stub_groups_valid_request

      expect(subject.result).to be_a Hash
    end
  end
end
