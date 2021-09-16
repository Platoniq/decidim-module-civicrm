# frozen_string_literal: true

require "spec_helper"

describe Decidim::Civicrm::Api::ListMembershipTypes, type: :class do
  subject { described_class.new }

  describe "#result" do
    before do
      stub_api_request(:list_membership_types)
    end

    let(:result) { subject.result }
    let(:membership_type) { subject.result.first }

    it "returns an Array with the result" do
      expect(result).to be_a Array
    end

    it "has an id and name for each MembershipType" do
      expect(membership_type[:id]).to eq 1
      expect(membership_type[:name]).to eq "Interested"
    end
  end
end
