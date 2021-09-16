# frozen_string_literal: true

require "spec_helper"

describe Decidim::Civicrm::Api::FindUser, type: :class do
  subject { described_class.new(42) }

  describe "#result" do
    before do
      stub_api_request(:find_user)
    end

    it "returns a Hash with the result" do
      expect(subject.result).to eq({
                                     contact: {
                                       id: 9999,
                                       display_name: "Arthur Dent"
                                     },
                                     memberships: [2, 3],
                                     user: {
                                       contact_id: 9999,
                                       email: "arthurdent@example.com",
                                       name: "arthur.dent",
                                       id: 42
                                     }
                                   })
    end
  end
end
