# frozen_string_literal: true

require "spec_helper"
require "decidim/proposals/test/factories"

describe "Restrict actions by CiviCRM verifications", type: :system do
  include_context "with a component"

  let(:manifest_name) { "proposals" }
  let(:options) { {} }
  let(:authorization_options) do
    {
      authorization_handlers: {
        handler_name => { "options" => options }
      }
    }
  end

  let!(:organization) do
    create(:organization, available_authorizations: %w(civicrm_basic civicrm_group civicrm_membership))
  end

  let!(:user) { create(:user, :confirmed, organization: organization) }
  let!(:proposal) { create(:proposal, component: component) }

  let!(:component) do
    create(
      :proposal_component,
      :with_creation_enabled,
      manifest: manifest,
      participatory_space: participatory_space,
      permissions: permissions
    )
  end

  before do
    switch_to_host(organization.host)
    login_as user, scope: :user
    visit main_component_path(component)
    click_link "New proposal"
  end

  after do
    expect_no_js_errors
  end

  shared_examples "user is authorized" do
    let!(:authorization) { create(:authorization, user: user, name: handler_name, metadata: metadata) }

    it do
      expect(page).to have_content "Create your proposal"
      expect(page).to have_selector ".new_proposal"
    end
  end

  shared_examples "user is authorized with wrong metadata" do
    let!(:authorization) { create(:authorization, user: user, name: handler_name, metadata: wrong_metadata) }

    it do
      expect(page).to have_link "Not authorized"
      expect(page).to have_content "isn't valid"
    end
  end

  shared_examples "user is not authorized" do
    let!(:authorization) { nil }

    it do
      expect(page).to have_link "Authorize"
      expect(page).to have_content "you need to be authorized"
    end
  end

  describe "Basic Verification" do
    let!(:permissions) { { create: authorization_options } }

    let(:handler_name) { "civicrm_basic" }
    let(:options) { {} }
    let(:metadata) { { "contact_id" => contact_id } }
    let(:wrong_metadata) { { "another_field" => "1" } }

    let(:contact_id) { 1 }
    let!(:contact) { create :decidim_civicrm_contact, organization: organization, user: user, civicrm_contact_id: contact_id }
    let!(:identity) { create :identity, user: user, provider: Decidim::Civicrm::PROVIDER_NAME, uid: contact_id }

    it_behaves_like "user is authorized"
    it_behaves_like "user is not authorized"
  end

  describe "Membership Verification" do
    let!(:permissions) { { create: authorization_options } }

    let(:handler_name) { "civicrm_membership" }
    let(:options) { { "civicrm_membership_types" => [1, 2] } }
    let(:metadata) { { "civicrm_membership_types" => [2, 3] } }
    let(:wrong_metadata) { { "civicrm_membership_types" => [3, 4] } }

    it_behaves_like "user is authorized"
    it_behaves_like "user is authorized with wrong metadata"
    it_behaves_like "user is not authorized"
  end

  describe "Group Verification" do
    let!(:permissions) { { create: authorization_options } }

    let(:handler_name) { "civicrm_group" }
    let(:options) { { "civicrm_groups" => [1, 2] } }
    let(:metadata) { { "contact_id" => contact_id } }
    let(:wrong_metadata) { { "contact_id" => "2" } }

    let(:contact_id) { 1 }

    let!(:identity) { create :identity, user: user, provider: Decidim::Civicrm::PROVIDER_NAME, uid: contact_id }
    let!(:contact) { create :decidim_civicrm_contact, organization: organization, user: user, civicrm_contact_id: contact_id }
    let(:group) { create :decidim_civicrm_group, organization: organization, civicrm_group_id: "1" }
    let!(:group_membership) { create :decidim_civicrm_group_membership, organization: organization, contact: contact, group: group }

    it_behaves_like "user is authorized"
    it_behaves_like "user is authorized with wrong metadata"
    it_behaves_like "user is not authorized"
  end

  def visit_proposal
    page.visit resource_locator(proposal).path
  end
end
