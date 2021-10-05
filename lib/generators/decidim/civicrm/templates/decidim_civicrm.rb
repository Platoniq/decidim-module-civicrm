# frozen_string_literal: true

require "omniauth/civicrm"

## Omniauth configuration

if Rails.application.secrets[:omniauth][:civicrm].present?
  Rails.application.config.middleware.use OmniAuth::Builder do
    provider :civicrm,
             Rails.application.secrets[:omniauth][:civicrm][:client_id],
             Rails.application.secrets[:omniauth][:civicrm][:client_secret],
             Rails.application.secrets[:omniauth][:civicrm][:site],
             scope: "openid profile email"
  end

  ActiveSupport::Notifications.subscribe(/^decidim\.user\.omniauth_registration/) do |_name, data|
    Decidim::Civicrm::ContactCreationJob.perform_later(data.to_json)
  end
end

## Verification worfklows

Decidim::Verifications.register_workflow(:civicrm_basic) do |workflow|
  workflow.form = "Decidim::Civicrm::Verifications::CivicrmBasic"
  workflow.engine = Decidim::Civicrm::Engine
  workflow.renewable = true
end

Decidim::Verifications.register_workflow(:civicrm_membership) do |workflow|
  workflow.action_authorizer = "Decidim::Civicrm::Verifications::MembershipActionAuthorizer"
  workflow.form = "Decidim::Civicrm::Verifications::CivicrmMembership"
  workflow.engine = Decidim::Civicrm::Engine
  workflow.options do |options|
    options.attribute :civicrm_membership_types, type: :array, choices: -> { Decidim::Civicrm::MembershipType.update_translations.pluck(:id) }
  end
  workflow.renewable = true
end

Decidim::Verifications.register_workflow(:civicrm_group) do |workflow|
  workflow.action_authorizer = "Decidim::Civicrm::Verifications::GroupActionAuthorizer"
  workflow.form = "Decidim::Civicrm::Verifications::CivicrmGroup"
  workflow.engine = Decidim::Civicrm::Engine
  workflow.options do |options|
    options.attribute :civicrm_groups, type: :array, choices: -> { Decidim::Civicrm::Group.update_translations.pluck(:id) }
  end
  workflow.renewable = true
end

## Event listeners

ActiveSupport::Notifications.subscribe(/^decidim\.civicrm\.contact\.created/) do |_name, contact_id|
  Decidim::Civicrm::ContactVerificationJob.perform_later(contact_id, "civicrm_basic")
  Decidim::Civicrm::ContactVerificationJob.perform_later(contact_id, "civicrm_membership")
  Decidim::Civicrm::ContactVerificationJob.perform_later(contact_id, "civicrm_group")
end
