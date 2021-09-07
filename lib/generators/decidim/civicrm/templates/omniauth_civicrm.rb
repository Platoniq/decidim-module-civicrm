# frozen_string_literal: true

require "omniauth/civicrm"

if Rails.application.secrets[:omniauth][:civicrm].present?
  Rails.application.config.middleware.use OmniAuth::Builder do
    provider :civicrm,
             Rails.application.secrets[:omniauth][:civicrm][:client_id],
             Rails.application.secrets[:omniauth][:civicrm][:client_secret],
             Rails.application.secrets[:omniauth][:civicrm][:site],
             scope: "openid profile email"
  end
end
