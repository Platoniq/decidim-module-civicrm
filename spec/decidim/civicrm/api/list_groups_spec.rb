# frozen_string_literal: true

require "spec_helper"

describe Decidim::Civicrm::Api::ListGroups, type: :class do
  subject { described_class.new }

  describe "#result" do
    before do
      stub_api_request(:list_groups)
    end

    let(:result) { subject.result }
    let(:group) { subject.result.first }

    it "returns an Array with the result" do
      expect(result).to be_a Array
    end

    it "has the right attributes for each Group" do
      expect(group).to eq(
        {
          id: 1,
          name: "Administrators",
          title: "Administrators",
          description: "The users in this group are assigned admin privileges.",
          group_type: [1]
        }
      )
    end
  end
end
