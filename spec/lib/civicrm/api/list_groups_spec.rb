# frozen_string_literal: true

require "spec_helper"
require "decidim/civicrm/test/shared_contexts"

module Decidim
  describe Civicrm::Api::ListGroups, type: :class do
    subject { described_class.new }

    include_context "with stubs example api"

    let(:data) { JSON.parse(file_fixture("group_valid_response.json").read) }

    describe "#result" do
      it_behaves_like "returns hash content", :groups
    end
  end
end
