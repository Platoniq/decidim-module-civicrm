# frozen_string_literal: true

require "spec_helper"
require "decidim/civicrm/test/shared_contexts"

module Decidim
  describe Civicrm::Api::FindContact, type: :class do
    subject { described_class.new(42) }

    include_context "with stubs example api"

    let(:data) { JSON.parse(file_fixture("contact_valid_response.json").read) }

    describe "#result" do
      it_behaves_like "returns a single object", :contact
    end
  end
end
