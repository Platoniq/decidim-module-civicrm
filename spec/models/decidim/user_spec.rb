# frozen_string_literal: true

require "spec_helper"

module Decidim
  describe User do
    let!(:user) { create(:user) }
    let!(:organization) { create(:organization) }

    describe "#civicrm_identity?" do
      subject { user.civicrm_identity? }

      context "when user has a civicrm-provided identity" do
        let!(:identity) { create(:identity, user: user, provider: Decidim::Civicrm::PROVIDER_NAME) }

        it { is_expected.to be_truthy }
      end

      context "when user doesn't have a civicrm-provided identity" do
        let!(:identity) { create(:identity, user: user, provider: "other") }

        it { is_expected.to be_falsey }
      end

      context "when user doesn't have an identity" do
        it { is_expected.to be_falsey }
      end
    end

    describe "#contact" do
      subject { user.contact }

      context "when user has a related civicrm contact" do
        let!(:contact) { create(:decidim_civicrm_contact, organization: organization, user: user) }

        it { is_expected.to be_a Decidim::Civicrm::Contact }
      end
    end
  end
end
