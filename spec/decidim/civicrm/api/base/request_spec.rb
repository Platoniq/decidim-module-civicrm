# frozen_string_literal: true

require "spec_helper"

describe Decidim::Civicrm::Api::Base::Request, type: :class do
  subject { described_class.new(params) }

  let(:params) do
    {

    }
  end

  describe "#base_params" do
    it "returns a Hash with params" do
      # TODO
    end
  end

  describe "#response" do
    it "returns a response parsed into a ruby Hash" do
      # TODO
    end
  end
end
