# frozen_string_literal: true

require "spec_helper"
require "decidim/civicrm/test/shared_contexts"

module Decidim::Civicrm
  describe JoinContactToParticipatorySpacesJob do
    subject { described_class }

    include_context "with stubs example api"

    let(:data) { JSON.parse(file_fixture("find_user_valid_response.json").read) }
    let(:user) { create :user, organization: organization }
    let!(:identity) { create :identity, user: user, provider: Decidim::Civicrm::OMNIAUTH_PROVIDER_NAME }
    let(:organization) { create :organization }
    let(:participatory_space) { create :participatory_process, organization: organization }
    let!(:civicrm_group_participatory_space) { create :civicrm_group_participatory_space, group: group, participatory_space: participatory_space }
    let!(:group) { create :civicrm_group, organization: organization }
    let!(:contact) { create :civicrm_contact, user: user, organization: organization, civicrm_contact_id: contact_id }
    let!(:civicrm_group_membership) { create :civicrm_group_membership, contact: contact, group: group }
    let(:contact_id) { data["id"] }

    it "creates a private user for the participatory space" do
      expect { subject.perform_now(contact.id) }.to change { Decidim::ParticipatorySpacePrivateUser.count }.from(0).to(1)
    end

    context "when no contact" do
      let(:another_user) { create :user, organization: organization }
      let(:contact) { create :civicrm_contact, organization: organization, civicrm_contact_id: contact_id }

      it "does nothing" do
        expect { subject.perform_now(contact.id) }.not_to(change { Decidim::ParticipatorySpacePrivateUser.count })
      end
    end

    context "when no groups" do
      let(:civicrm_group_membership) { nil }

      it "does nothing" do
        expect { subject.perform_now(contact.id) }.not_to(change { Decidim::ParticipatorySpacePrivateUser.count })
      end
    end

    context "when group has no participatory spaces" do
      let(:civicrm_group_participatory_space) { nil }

      it "does nothing" do
        expect { subject.perform_now(contact.id) }.not_to(change { Decidim::ParticipatorySpacePrivateUser.count })
      end
    end

    context "when participatory space has no private users" do
      let(:participatory_space) { double(id: 1) }
      let(:civicrm_group_participatory_space) { nil }

      it "does nothing" do
        expect { subject.perform_now(contact.id) }.not_to(change { Decidim::ParticipatorySpacePrivateUser.count })
      end
    end
  end
end
