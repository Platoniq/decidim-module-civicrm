# frozen_string_literal: true

module Decidim
  module Civicrm
    module Admin
      class GroupsController < Decidim::Admin::ApplicationController
        include Paginable
        include NeedsPermission
        helper Decidim::Messaging::ConversationHelper

        helper_method :group, :groups, :members

        layout "decidim/admin/civicrm"

        def index
          # enforce_permission_to :index, :civicrm_groups
        end

        def show
          # enforce_permission_to :show, :civicrm_groups
        end

        def sync
          # enforce_permission_to :update, :civicrm_groups

          if group.present?
            SyncGroupJob.perform_later(group.id)
            flash[:notice] = t("success", scope: "decidim.civicrm.admin.groups.sync")
            redirect_to decidim_civicrm_admin.group_path(group)
          else
            SyncGroupsJob.perform_later(current_organization.id)
            flash[:notice] = t("success", scope: "decidim.civicrm.admin.groups.sync")
            redirect_to decidim_civicrm_admin.groups_path
          end

          # TODO: send email when complete?
        end

        private
        
        def groups
          paginate(all_groups)
        end

        def group
          return if params[:id].blank?

          @group ||= all_groups.find(params[:id])
        end

        def all_groups
          @all_groups ||= Group.where(organization: current_organization).order(id: :asc)
        end

        def members
          paginate(group.members)
        end
      end
    end
  end
end
