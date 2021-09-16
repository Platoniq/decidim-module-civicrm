# frozen_string_literal: true

require "spec_helper"

# rubocop:disable RSpec/DescribeClass
describe "Automatic verification after oauth sign up" do
  context "when a user is registered with omniauth" do
    let!(:user) { create(:user) }

    it "runs the ContactCreationJob" do
      expect do
        ActiveSupport::Notifications.publish(
          "decidim.user.omniauth_registration",
          user_id: user.id,
          identity_id: 1234,
          provider: "civicrm",
          uid: "aaa",
          email: user.email,
          name: "Civicrm User",
          nickname: "civicrm_user",
          avatar_url: "http://www.example.com/foo.jpg",
          raw_data: {}
        )
      end.to have_enqueued_job(Decidim::Civicrm::ContactCreationJob)
    end
  end

  context "when a contact is created" do
    let!(:contact) { create(:decidim_civicrm_contact) }

    it "runs the ContactVerificationJob" do
      expect do
        ActiveSupport::Notifications.publish(
          "decidim.civicrm.contact.created",
          contact_id: contact.id
        )
      end.to have_enqueued_job(Decidim::Civicrm::ContactVerificationJob)
    end
  end
end

# rubocop:enable RSpec/DescribeClass
