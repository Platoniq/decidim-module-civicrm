# frozen_string_literal: true

require "spec_helper"

describe "Decidim CiViCRM Admin section", type: :system do
  let!(:organization) { create :organization }
  let!(:user) { create :user, :admin, organization: organization }

  let!(:groups) { create_list :decidim_civicrm_group, 3, organization: organization }
  let!(:membership_types) { create_list :decidim_civicrm_membership_type, 3, organization: organization }

  let!(:contact) { create :decidim_civicrm_contact, organization: organization }
  let!(:group_membership) { create :decidim_civicrm_group_membership, contact: contact, group: groups.first, organization: organization }

  before do
    switch_to_host(organization.host)
    sign_in user
    visit decidim_admin.root_path
  end

  it "renders the expected menu" do
    within ".main-nav" do
      expect(page).to have_content("CiViCRM")
    end

    click_link "CiViCRM"

    within ".secondary-nav" do
      expect(page).to have_link("Groups")
      expect(page).to have_link("Membership Types")
    end
  end

  describe "Groups page" do
    before do
      visit decidim_civicrm_admin.groups_path
    end

    it "loads the page" do
      expect(page).to have_content("Groups")
      expect(page).to have_link("Synchronize with CiViCRM")

      within ".civicrm-groups" do
        expect(page).to have_content(groups[0].title)
        expect(page).to have_content(groups[1].title)
        expect(page).to have_content(groups[2].title)
      end
    end
  end

  describe "Group members page" do
    before do
      visit decidim_civicrm_admin.group_path(groups.first)
    end

    it "loads the page" do
      expect(page).to have_content("Group members")
      expect(page).to have_content(groups.first.title)

      within ".civicrm-group-members" do
        expect(page).to have_content(contact.user.name)
        expect(page).to have_content(contact.user.nickname)
      end
    end
  end

  describe "Membership Types page" do
    before do
      visit decidim_civicrm_admin.membership_types_path
    end

    it "loads the page" do
      expect(page).to have_content("Membership Types")
      expect(page).to have_link("Synchronize with CiViCRM")

      within ".civicrm-membership-types" do
        expect(page).to have_content(membership_types[0].name)
        expect(page).to have_content(membership_types[1].name)
        expect(page).to have_content(membership_types[2].name)
      end
    end
  end
end
