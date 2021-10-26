# frozen_string_literal: true

module Decidim
  module Civicrm
    module Admin
      class MeetingsController < Decidim::Admin::ApplicationController
        include Paginable
        include NeedsPermission
        include TranslatableAttributes

        layout "decidim/admin/civicrm"

        helper_method :meeting_redirections, :meeting_redirection, :meetings, :meetings_list, :meeting_title

        def index
          # enforce_permission_to :index, :civicrm_meetings
        end

        def new
          @form = form(Decidim::Civicrm::Admin::MeetingRedirectionForm).instance
        end

        def create
          @form = form(Decidim::Civicrm::Admin::MeetingRedirectionForm).from_params(params)
          CreateMeetingRedirection.call(@form) do
            on(:ok) do
              flash[:notice] = t(".success")

              redirect_to decidim_civicrm_admin.meetings_path
            end

            on(:invalid) do
              flash[:alert] = t(".error")
              redirect_to decidim_civicrm_admin.meetings_path
            end
          end
        end

        def destroy
          meeting_redirection.destroy!
          redirect_to decidim_civicrm_admin.meetings_path
        end

        def toggle_active
          # enforce_permission_to :update, :civicrm_groups

          return if meeting_redirection.blank?

          meeting_redirection.active = !meeting_redirection.active
          meeting_redirection.save!
          redirect_to decidim_civicrm_admin.meetings_path
        end

        private

        def all_meeting_redirections
          Decidim::Civicrm::MeetingRedirection.where(organization: current_organization)
        end

        def meeting_redirections
          paginate(all_meeting_redirections)
        end

        def meeting_redirection
          return if params[:id].blank?

          @meeting_redirection ||= all_meeting_redirections.find(params[:id])
        end

        def meetings
          return @meetings if @meetings

          classes = Decidim.participatory_space_manifests.pluck :model_class_name
          components = []
          classes.each do |klass|
            spaces = klass.safe_constantize.where(organization: current_organization)
            spaces.each do |space|
              components.concat Decidim::Component.where(participatory_space: space).pluck(:id)
            end
          end
          @meetings = Decidim::Meetings::Meeting.where(decidim_component_id: components)
        end

        def meeting_title(meeting)
          "#{translated_attribute(meeting.participatory_space.title)} / #{translated_attribute(meeting.component.name)} / #{translated_attribute(meeting.title)}"
        end

        def meetings_list
          @meetings_list ||= meetings.map do |meeting|
            [meeting_title(meeting), meeting.id]
          end
        end

        def per_page
          50
        end
      end
    end
  end
end
