# frozen_string_literal: true

if !Rails.env.production? || ENV["SEED"]
  print "Creating seeds for decidim_civicrm...\n" unless Rails.env.test?

  organization = Decidim::Organization.first

  user = Decidim::User.find_by(
    organization: organization,
    email: "user@example.org"
  )

  contact = Decidim::Civicrm::Contact.create!(
    organization: organization,
    user: user,
    civicrm_contact_id: 1
  )

  group = Decidim::Civicrm::Group.create!(
    organization: organization,
    civicrm_group_id: 1,
    civicrm_member_count: 2,
    title: "Test Group",
    description: "This is a Test Group automatically generated to have some content.",
  )

  Decidim::Civicrm::GroupMembership.create!(
    organization: organization,
    contact: contact,
    group: group
  )
end
