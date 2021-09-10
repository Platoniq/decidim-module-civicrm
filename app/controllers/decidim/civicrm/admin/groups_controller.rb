# frozen_string_literal: true

module Decidim
  module Civicrm
    module Admin
      class GroupsController < Decidim::Admin::ApplicationController
        include Paginable
        include NeedsPermission

        helper_method :groups, :members

        layout "decidim/admin/users"

        def index
          # enforce_permission_to :index, :civicrm_groups
        end
        
        def show
          # enforce_permission_to :show, :civicrm_groups
        end

        def sync
          # enforce_permission_to :update, :civicrm_groups

          SyncGroupsJob.perform_later(current_organization.id)
          
          flash[:notice] = t("success", scope: "decidim.civicrm.admin.groups.sync")

          redirect_to decidim_civicrm_admin.groups_path
          # TODO notification ok
          # TODO send email when complete?
        end

        def groups
          paginate(all_groups)
        end

        def all_groups
          @all_groups ||= Group.where(organization: current_organization)
        end
        
        def members(group)
          @members ||= GroupMembership.where(organization: current_organization, group: group)
        end
      end
    end
  end
end
