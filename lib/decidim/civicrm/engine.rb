# frozen_string_literal: true

require "omniauth/civicrm"

module Decidim
  module Civicrm
    # This is the engine that runs on the public interface of decidim-civicrm.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Civicrm

      # Prepare a zone to create overrides
      # https://edgeguides.rubyonrails.org/engines.html#overriding-models-and-controllers
      # overrides
      config.to_prepare do
        Decidim::User.include(Decidim::Civicrm::CivicrmUserAddons)
        # omniauth only trigger notifications when a new user is registered
        # this adds a notification too when user logs in
        Decidim::CreateOmniauthRegistration.include(Decidim::Civicrm::CreateOmniauthRegistrationOverride)
        Decidim::Admin::ResourcePermissionsController.include(Decidim::Civicrm::Admin::NeedsMultiselectSnippets)
      end

      initializer "decidim_civicrm.omniauth" do
        next unless Decidim::Civicrm.omniauth && Decidim::Civicrm.omniauth[:client_id]

        Rails.application.config.middleware.use OmniAuth::Builder do
          provider Decidim::Civicrm::OMNIAUTH_PROVIDER_NAME,
                   client_id: Decidim::Civicrm.omniauth[:client_id],
                   client_secret: Decidim::Civicrm.omniauth[:client_secret],
                   site: Decidim::Civicrm.omniauth[:site],
                   scope: "openid profile email"
        end
      end

      initializer "decidim_civicrm.user_contact_sync" do
        # Trigger contact creation & synchronization with internal tables
        ActiveSupport::Notifications.subscribe "decidim.user.omniauth_registration" do |_name, data|
          Decidim::Civicrm::OmniauthContactSyncJob.perform_later(data)
        end
        # Trigger autho-verification after sync a contact
        ActiveSupport::Notifications.subscribe "decidim.civicrm.contact.updated" do |_name, data|
          Decidim::Civicrm::AutoVerificationJob.perform_later(data)
        end
      end

      initializer "decidim_civicrm.authorizations" do
        next unless Decidim::Civicrm.authorizations

        if Decidim::Civicrm.authorizations.include?(:civicrm)
          # Generic verification method using civicrm contacts
          # A omniauth operation will try to use this method to obtain the contact_id and store it
          # as an extended_data attribute of the user
          Decidim::Verifications.register_workflow(:civicrm) do |workflow|
            workflow.form = "Decidim::Civicrm::Verifications::Civicrm"

            # workflow.options do |options|
            #   options.attribute :role, type: :enum, choices: -> { Decidim::Civicrm::Api::User::ROLES.values.map(&:to_s) }
            #   options.attribute :regional_scope, type: :enum, choices: -> { Decidim::Civicrm::Api::RegionalScope::ALL.keys.map(&:to_s) }
            # end
          end
        end

        if Decidim::Civicrm.authorizations.include?(:civicrm_groups)
          # # Another automated verification method that stores all the groups obtained from civicrm
          Decidim::Verifications.register_workflow(:civicrm_groups) do |workflow|
            workflow.form = "Decidim::Civicrm::Verifications::CivicrmGroups"
            workflow.action_authorizer = "Decidim::Civicrm::Verifications::Groups::GroupsActionAuthorizer"

            workflow.options do |options|
              # options.attribute :group, type: :enum, choices: -> { Decidim::Civicrm::Api::Request.new.fetch_groups.map { |g| g[:name].downcase.to_sym } }
              options.attribute :groups, type: :string
            end
          end
        end
      end
    end
  end
end
