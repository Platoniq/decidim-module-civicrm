# frozen_string_literal: true

module Decidim
  module Civicrm
    module Admin
      class GroupsController < Decidim::Admin::ApplicationController
        include Paginable
        include NeedsPermission
        helper Decidim::Messaging::ConversationHelper

        helper_method :group, :groups, :members, :last_sync_class

        layout "decidim/admin/civicrm"

        def index
          # enforce_permission_to :index, :civicrm_groups
          respond_to do |format|
            format.html
            format.json do
              render json: json_groups
            end
          end
        end

        def show
          # enforce_permission_to :show, :civicrm_groups
        end

        def sync
          # enforce_permission_to :update, :civicrm_groups

          if group.present?
            SyncGroupMembersJob.perform_later(group.id)
            flash[:notice] = t("success", scope: "decidim.civicrm.admin.groups.sync")
            redirect_to decidim_civicrm_admin.group_path(group)
          else
            SyncAllGroupsJob.perform_later(current_organization.id)
            flash[:notice] = t("success", scope: "decidim.civicrm.admin.groups.sync")
            redirect_to decidim_civicrm_admin.groups_path
          end

          # TODO: send email when complete?
        end

        def toggle_auto_sync
          return if group.blank?

          group.auto_sync_members = !group.auto_sync_members
          group.save!
          redirect_to decidim_civicrm_admin.groups_path
        end

        private

        def json_groups
          query = groups.where(auto_sync_members: true)
          query = if params[:ids]
                    query.where(civicrm_group_id: params[:ids])
                  else
                    query.where("title ILIKE ?", "%#{params[:q]}%")
                  end
          query.map do |item|
            {
              id: item.civicrm_group_id,
              text: item.title
            }
          end
        end

        def groups
          paginate(all_groups)
        end

        def group
          return if params[:id].blank?

          @group ||= all_groups.find(params[:id])
        end

        def all_groups
          @all_groups ||= Group.where(organization: current_organization).order(auto_sync_members: :desc, title: :asc)
        end

        def members
          paginate(group.group_memberships.order("contact_id desc nulls last", "extra ->>'display_name' ASC"))
        end

        def last_sync_class(datetime)
          return unless datetime

          return "alert" if datetime < 1.week.ago
          return "warning" if datetime < 1.day.ago

          "success"
        end

        def per_page
          50
        end
      end
    end
  end
end
