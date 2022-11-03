# frozen_string_literal: true

Decidim::Civicrm.configure do |config|
  # Configure api credentials
  config.api = {
    api_key: Rails.application.secrets.dig(:civicrm, :api, :api_key),
    site_key: Rails.application.secrets.dig(:civicrm, :api, :site_key),
    url: Rails.application.secrets.dig(:civicrm, :api, :url)
  }

  # Configure omniauth secrets
  config.omniauth = {
    client_id: Rails.application.secrets.dig(:omniauth, :civicrm, :client_id),
    client_secret: Rails.application.secrets.dig(:omniauth, :civicrm, :client_secret),
    site: Rails.application.secrets.dig(:omniauth, :civicrm, :site),
    icon_path: Rails.application.secrets.dig(:omniauth, :civicrm, :icon_path)
  }

  # whether to send notifications to user when they auto-verified or not:
  # config.send_verification_notifications = false

  # array with civirm group ids that will automatically (cron based) syncronize contact memberships
  config.auto_sync_groups = Rails.application.secrets.dig(:civicrm, :auto_sync_groups)
end
