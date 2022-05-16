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
      config.after_initialize do
        Decidim::User.include(Decidim::Civicrm::CivicrmUserAddons)
        # omniauth only trigger notifications when a new user is registered
        # this adds a notification too when user logs in
        Decidim::CreateOmniauthRegistration.include(Decidim::Civicrm::CreateOmniauthRegistrationOverride)
        Decidim::Admin::ResourcePermissionsController.include(Decidim::Civicrm::Admin::NeedsMultiselectSnippets)
        Decidim::Meetings::RegistrationsController.include(Decidim::Civicrm::MeetingsRegistrationsControllerOverride)
        Decidim::Meetings::JoinMeeting.include(Decidim::Civicrm::JoinMeetingOverride)
      end

      routes do
        root to: "authorizations#new"
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
        ActiveSupport::Notifications.subscribe "decidim.civicrm.contact.updated" do |_name, data|
          # Trigger autho-verification after sync a contact
          Decidim::Civicrm::AutoVerificationJob.perform_later(data)
          # Trigger membership as private user in configured participatory spaces
          Decidim::Civicrm::JoinContactToParticipatorySpacesJob.perform_later(data)
        end

        # Trigger participatory spaces private members sync
        ActiveSupport::Notifications.subscribe "decidim.civicrm.group_membership.updated" do |_name, data|
          Decidim::Civicrm::ParticipatorySpaceGroupMembershipJob.perform_later(data)
        end
      end

      initializer "decidim_civicrm.authorizations" do
        next unless Decidim::Civicrm.authorizations

        if Decidim::Civicrm.authorizations.include?(:civicrm)
          # Generic verification method using civicrm contacts
          Decidim::Verifications.register_workflow(:civicrm) do |workflow|
            workflow.form = "Decidim::Civicrm::Verifications::Civicrm"
          end
        end

        if Decidim::Civicrm.authorizations.include?(:civicrm_groups)
          # # Another automated verification method that stores all the groups obtained from civicrm
          Decidim::Verifications.register_workflow(:civicrm_groups) do |workflow|
            workflow.form = "Decidim::Civicrm::Verifications::CivicrmGroups"
            workflow.action_authorizer = "Decidim::Civicrm::Verifications::GroupsActionAuthorizer"

            workflow.options do |options|
              options.attribute :groups, type: :string
            end
          end
        end

        if Decidim::Civicrm.authorizations.include?(:civicrm_membership_types)
          # # Another automated verification method that stores all the memberships obtained from civicrm
          Decidim::Verifications.register_workflow(:civicrm_membership_types) do |workflow|
            workflow.form = "Decidim::Civicrm::Verifications::CivicrmMembershipTypes"
            workflow.action_authorizer = "Decidim::Civicrm::Verifications::MembershipTypesActionAuthorizer"

            workflow.options do |options|
              options.attribute :membership_types, type: :string
            end
          end
        end
      end

      initializer "decidim_civicrm.events_sync" do
        next unless Decidim::Civicrm.auto_sync_meetings_event_attributes.is_a?(Hash)

        # triggers civicrm api submissions for events
        Decidim::EventsManager.subscribe(/^decidim\.events\./) do |event_name, data|
          Decidim::Civicrm::EventSyncJob.perform_later(event_name, data)
        end
      end
    end
  end
end
