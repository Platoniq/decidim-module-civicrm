# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Civicrm
    describe CivicrmHelper do
      let!(:organization) { create(:organization) }
      let!(:user) { create(:user, organization: organization) }
      let!(:identity) { create(:identity, user: user, provider: "civicrm") }
      
      describe "#civicrm_user?" do
        subject { helper.civicrm_user?(user) }
        
        it { is_expected.to be_truthy }
        
        context "when user doesn't have a civicrm-provided identity" do
          let!(:identity) { create(:identity, user: user, provider: "other") }

          it { is_expected.to be_falsey }
        end
      end
    end
  end
end
