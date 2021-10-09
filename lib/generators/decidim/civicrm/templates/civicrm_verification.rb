# frozen_string_literal: true

# Decidim::Verifications.register_workflow(:civicrm) do |workflow|
#   workflow.form = "Decidim::Civicrm::Verifications::CivicrmVerification"
# end

# ActiveSupport::Notifications.subscribe(/^decidim\.user\.omniauth_registration/) do |_name, data|
#   Decidim::Civicrm::ContactCreationJob.perform_later(data.to_json)
# end

# ActiveSupport::Notifications.subscribe(/^decidim\.civicrm\.contact.created/) do |_name, contact_id|
#   Decidim::Civicrm::ContactVerificationJob.perform_later(contact_id)
# end
