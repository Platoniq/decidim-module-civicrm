# frozen_string_literal: true

ActiveSupport::Notifications.subscribe(/^decidim\.user\.omniauth_registration/) do |_name, data|
  # Decidim::Civicrm::Verifications::VerificationJob.perform_later(data)

  # TODO: get gem to load job (ERROR: constant not found Decidim::Civicrm::Verifications::VerificationJob)
end
