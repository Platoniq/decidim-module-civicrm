# frozen_string_literal: true

require "spec_helper"

describe Decidim::Civicrm::Api::FindGroup, type: :class do
  subject { described_class.new(1) }

  describe "#result" do
    before do
      stub_api_request(:find_group)
    end

    it "returns a Hash with the result" do
      expect(subject.result).to eq(
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
