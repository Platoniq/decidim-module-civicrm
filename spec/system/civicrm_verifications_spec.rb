# frozen_string_literal: true

require "spec_helper"
require "decidim/proposals/test/factories"

describe "Restrict actions by CiviCRM verifications", type: :system do
  let(:options) { {} }
  let!(:organization) do
    create(:organization, available_authorizations: %w(civicrm civicrm_groups civicrm_membership_types))
  end
  let(:participatory_process) do
    create(:participatory_process, :with_steps, organization: organization)
  end

  let!(:user) { create(:user, :confirmed, organization: organization) }
  let!(:proposal) { create(:proposal, component: component) }

  let!(:component) do
    create(
      :proposal_component,
      :with_creation_enabled,
      participatory_space: participatory_process
    )
  end
  let!(:contact) { create :civicrm_contact, organization: organization, user: user, civicrm_contact_id: contact_id, civicrm_uid: uid }
  let!(:identity) { create :identity, user: user, provider: Decidim::Civicrm::OMNIAUTH_PROVIDER_NAME, uid: uid }
  let(:contact_id) { 1 }
  let(:uid) { 3 }
  let!(:authorization) { create(:authorization, :granted, user: user, name: handler_name, metadata: metadata) }
  let(:group) { create :civicrm_group, organization: organization, civicrm_group_id: "1" }
  let!(:group_membership) { create :civicrm_group_membership, contact: contact, group: group }
  let!(:membership_type) { create :civicrm_membership_type, organization: organization, civicrm_membership_type_id: "2" }

  before do
    switch_to_host(organization.host)
    login_as user, scope: :user
    permissions = {
      create: {
        authorization_handlers: {
          handler_name => { "options" => options }
        }
      }
    }
    component.update!(permissions: permissions)

    visit main_component_path(component)
    click_link "New proposal"
  end

  after do
    expect_no_js_errors
  end

  shared_examples "user is authorized" do
    it do
      expect(page).to have_content "Create your proposal"
      expect(page).to have_selector ".new_proposal"
    end
  end

  shared_examples "user is authorized with wrong metadata" do
    it do
      expect(page).to have_content "Not authorized"
      expect(page).to have_content "isn't valid"
      expect(page).not_to have_content "Create your proposal"
    end
  end

  shared_examples "user is not authorized" do
    it do
      expect(page).to have_link "Authorize"
      expect(page).to have_content "you need to be authorized"
    end
  end

  describe "Basic Verification" do
    let(:handler_name) { "civicrm" }
    let(:options) { {} }
    let(:metadata) { { "contact_id" => contact_id, "uid" => uid } }

    it_behaves_like "user is authorized"

    context "when no authorization" do
      let!(:authorization) { nil }

      it_behaves_like "user is not authorized"
    end
  end

  describe "Membership Verification" do
    let(:handler_name) { "civicrm_membership_types" }
    let(:metadata) { { "membership_type_ids" => [2, 3] } }
    let(:options) { { "membership_types" => "1, 2" } }

    it_behaves_like "user is authorized"

    context "when wrong metadata" do
      let(:metadata) { { "membership_types" => [3, 4] } }

      it_behaves_like "user is authorized with wrong metadata"
    end

    context "when no authorization" do
      let!(:authorization) { nil }

      it_behaves_like "user is not authorized"
    end
  end

  describe "Group Verification" do
    let(:handler_name) { "civicrm_groups" }
    let(:metadata) { { "group_ids" => [1, 3] } }
    let(:options) { { "groups" => "1, 2" } }

    it_behaves_like "user is authorized"

    context "when wrong metadata" do
      let(:metadata) { { "contact_id" => "2" } }

      it_behaves_like "user is authorized with wrong metadata"
    end

    context "when no authorization" do
      let!(:authorization) { nil }

      it_behaves_like "user is not authorized"
    end
  end

  def visit_proposal
    page.visit resource_locator(proposal).path
  end
end
