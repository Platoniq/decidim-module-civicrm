# frozen_string_literal: true

require "decidim/core/test/factories"

FactoryBot.define do
  factory :decidim_civicrm_contact, class: "Decidim::Civicrm::Contact" do
    user
    organization
    civicrm_contact_id { Faker::Number.between(from: 1, to: 100) }
    extra do
      {
        extra_attribute: "123"
      }
    end
  end

  factory :decidim_civicrm_group, class: "Decidim::Civicrm::Group" do
    organization
    civicrm_group_id { Faker::Number.between(from: 1, to: 100) }
    title { Faker::Lorem.sentence(word_count: 2) }
    description { Faker::Lorem.paragraph(sentence_count: 2) }
    extra do
      {
        extra_attribute: "123"
      }
    end
  end

  factory :decidim_civicrm_group_membership, class: "Decidim::Civicrm::GroupMembership" do
    organization
    group factory: :decidim_civicrm_group
    contact factory: :decidim_civicrm_contact
  end

  factory :decidim_civicrm_membership_type, class: "Decidim::Civicrm::MembershipType" do
    organization
    civicrm_membership_type_id { Faker::Number.unique.between(from: 1, to: 100) }
    name { Faker::Lorem.word }
  end
end
