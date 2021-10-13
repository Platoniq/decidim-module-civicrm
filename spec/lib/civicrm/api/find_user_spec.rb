# frozen_string_literal: true

require "spec_helper"
require "decidim/civicrm/test/shared_contexts"

module Decidim
  describe Civicrm::Api::FindUser, type: :class do
    subject { described_class.new(42) }

    include_context "with stubs example api"

    let(:data) { JSON.parse(file_fixture("user_valid_response.json").read) }

    describe "#result" do
      it "returns a mapped object" do
        expect(subject.result).to be_a Hash
        expect(subject.result[:user][:contact_id]).to eq(data["values"].first["contact_id"])
        expect(subject.result[:user][:email]).to eq(data["values"].first["email"])
        expect(subject.result[:user][:id]).to eq(data["values"].first["id"])
        expect(subject.result[:user][:name]).to eq(data["values"].first["name"])
      end
    end
  end
end
