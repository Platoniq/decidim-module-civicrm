# frozen_string_literal: true

ActiveSupport::Notifications.subscribe(/^decidim\.user\.omniauth_registration/) do |_name, data|
  Decidim::Civicrm::VerificationJob.perform_later(data)
end
