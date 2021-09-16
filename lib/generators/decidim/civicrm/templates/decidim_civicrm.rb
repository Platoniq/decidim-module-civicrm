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

Decidim::Verifications.register_workflow(:civicrm) do |workflow|
  workflow.form = "Decidim::Civicrm::Verifications::CivicrmVerification"
end

## Event listeners

ActiveSupport::Notifications.subscribe(/^decidim\.civicrm\.contact\.created/) do |_name, contact_id|
  Decidim::Civicrm::ContactVerificationJob.perform_later(contact_id)
end
