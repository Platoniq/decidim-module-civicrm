# frozen_string_literal: true

require "decidim/civicrm/admin"
require "decidim/civicrm/admin_engine"
require "decidim/civicrm/api"
require "decidim/civicrm/engine"
require "decidim/civicrm/verifications"
require "decidim/civicrm/verifications/groups_action_authorizer"
require "decidim/civicrm/version"

module Decidim
  # This namespace holds the logic of the `decidim-civicrm` module.
  module Civicrm
    include ActiveSupport::Configurable

    OMNIAUTH_PROVIDER_NAME = "civicrm"

    # setup API credentials
    config_accessor :api do
      {
        key: nil,
        secret: nil,
        url: nil
      }
    end

    # setup a hash with :client_id, :client_secret and :site to enable omniauth authentication
    config_accessor :omniauth do
      {
        client_id: nil,
        client_secret: nil,
        site: nil
      }
    end

    # authorizations enabled
    config_accessor :authorizations do
      [:civicrm, :civicrm_groups]
    end

    # if false, no notifications will be send to users when automatic verifications are performed
    config_accessor :send_verification_notifications do
      true
    end

    # array with civirm group ids that will automatically (cron based) syncronize contact memberships
    # note that admins can override these groups in the app
    config_accessor :auto_sync_groups do
      []
    end

    # Hash with default correspondences between decidim_meeting_id => civicrm_event_id
    # New meetings created in decidim will generate a new event in CiViCRM automatically
    # set to false to disable this functionality
    config_accessor :auto_sync_meetings do
      {}
    end

    # unless false, meeting registrations will be posted to CiViCRM and syncronized back according to the status
    # set to false to disable this functionality
    config_accessor :auto_sync_meeting_registrations do
      {}
    end

    class Error < StandardError; end
  end
end
