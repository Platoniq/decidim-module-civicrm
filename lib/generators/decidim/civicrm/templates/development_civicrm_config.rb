# frozen_string_literal: true

# Skip secrets.yml conf to facilitate development rebuilds
Decidim::Civicrm.configure do |config|
  # Configure api credentials
  config.api = {
    api_key: ENV["CIVICRM_VERIFICATION_API_KEY"],
    site_key: ENV["CIVICRM_VERIFICATION_SITE_KEY"],
    url: ENV["CIVICRM_VERIFICATION_URL"]
  }

  # Configure omniauth secrets
  config.omniauth = {
    enabled: true,
    client_id: ENV["CIVICRM_CLIENT_ID"],
    client_secret: ENV["CIVICRM_CLIENT_SECRET"],
    site: ENV["CIVICRM_SITE"]
  }

  Rails.application.secrets[:omniauth][:civicrm] = config.omniauth

  # whether to send notifications to user when they auto-verified or not:
  # config.send_verification_notifications = false

  # array with civirm group ids that will automatically (cron based) syncronize contact memberships
  config.auto_sync_groups = Rails.application.secrets.dig(:civicrm, :auto_sync_groups)
end
