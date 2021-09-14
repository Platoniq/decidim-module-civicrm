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
    group
    contact
  end
end
