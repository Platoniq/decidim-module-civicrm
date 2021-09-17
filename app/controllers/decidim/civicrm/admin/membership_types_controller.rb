# frozen_string_literal: true

module Decidim
  module Civicrm
    module Admin
      class MembershipTypesController < Decidim::Admin::ApplicationController
        include Paginable
        include NeedsPermission

        helper_method :membership_types

        layout "decidim/admin/civicrm"

        def index
          # enforce_permission_to :index, :civicrm_membership_types
        end

        def sync
          # enforce_permission_to :update, :civicrm_membership_types

          SyncMembershipTypesJob.perform_later(current_organization.id)
          flash[:notice] = t("success", scope: "decidim.civicrm.admin.membership_types.sync")
          redirect_to decidim_civicrm_admin.membership_types_path

          # TODO: send email when complete?
        end

        private

        def membership_types
          paginate(all_membership_types)
        end

        def all_membership_types
          @all_membership_types ||= MembershipType.where(organization: current_organization).order(id: :asc)
        end
      end
    end
  end
end
