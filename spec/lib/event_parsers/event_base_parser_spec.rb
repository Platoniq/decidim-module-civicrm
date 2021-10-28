# frozen_string_literal: true

require "spec_helper"

module Decidim::Civicrm
  describe EventParsers::EventBaseParser, type: :class do
    subject { described_class.new }

    describe "interface" do
      it "raise notimplement" do
        expect { subject.json }.to raise_error NotImplementedError
        expect { subject.save! }.to raise_error NotImplementedError
      end

      it "is invalid" do
        expect(subject.valid?).to eq(false)
      end
    end
  end
end
