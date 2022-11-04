# frozen_string_literal: true

require "decidim/core/test/factories"
require "decidim/meetings/test/factories"

FactoryBot.define do
  factory :civicrm_contact, class: "Decidim::Civicrm::Contact" do
    user
    organization
    civicrm_contact_id { Faker::Number.between(from: 1, to: 1000) }
    extra do
      {
        extra_attribute: "123"
      }
    end
  end

  factory :civicrm_group, class: "Decidim::Civicrm::Group" do
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

  factory :civicrm_group_membership, class: "Decidim::Civicrm::GroupMembership" do
    group factory: :civicrm_group
    contact factory: :civicrm_contact
    civicrm_contact_id { Faker::Number.between(from: 1, to: 1000) }
    extra do
      {
        display_name: Faker::Name.name,
        email: Faker::Internet.email
      }
    end
  end

  factory :civicrm_group_participatory_space, class: "Decidim::Civicrm::GroupParticipatorySpace" do
    group factory: :civicrm_group
    association :participatory_space, factory: :participatory_process
  end

  factory :civicrm_event_meeting, class: "Decidim::Civicrm::EventMeeting" do
    organization
    meeting factory: :meeting
    redirect_url { Faker::Internet.url }
    redirect_active { true }
    civicrm_event_id { Faker::Number.between(from: 1, to: 100) }

    trait :minimal do
      meeting { nil }
      redirect_url { nil }
      redirect_active { false }
    end
  end

  factory :civicrm_event_registration, class: "Decidim::Civicrm::EventRegistration" do
    event_meeting factory: :civicrm_event_meeting
    meeting_registration factory: :meeting_registrationg
    civicrm_event_registration_id { Faker::Number.between(from: 1, to: 100) }
  end

  factory :civicrm_membership_type, class: "Decidim::Civicrm::MembershipType" do
    organization
    civicrm_membership_type_id { Faker::Number.unique.between(from: 1, to: 100) }
    name { Faker::Lorem.word }
  end
end
