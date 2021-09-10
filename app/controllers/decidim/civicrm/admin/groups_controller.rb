# frozen_string_literal: true

module Decidim
  module Civicrm
    module Admin
      class GroupsController < Decidim::Admin::ApplicationController
        include NeedsPermission

        helper_method :groups, :members

        layout "decidim/admin/users"

        def index
          # enforce_permission_to :index, :civicrm_groups
        end
        
        def show
          # enforce_permission_to :show, :civicrm_groups
        end

        def update
          # enforce_permission_to :index, :civicrm_groups
        end

        def groups
          @groups ||= Group.where(organization: current_organization)
        end
        
        def members(group)
          @members ||= GroupMembership.where(organization: current_organization, group: group)
        end
      end
    end
  end
end
