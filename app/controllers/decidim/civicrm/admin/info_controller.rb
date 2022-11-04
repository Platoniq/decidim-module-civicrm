# frozen_string_literal: true

module Decidim
  module Civicrm
    module Admin
      class InfoController < Decidim::Admin::ApplicationController
        include Paginable
        include NeedsPermission

        helper CivicrmHelpers

        layout "decidim/admin/civicrm"

        def index
          # enforce_permission_to :index, :info
        end
      end
    end
  end
end
