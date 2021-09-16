# frozen_string_literal: true

module Decidim
  module Civicrm
    class AuthorizationsController < Decidim::ApplicationController
      def new
        flash[:alert] = t("authorizations.new.no_action", scope: "decidim.verifications")
        redirect_to decidim_verifications.authorizations_path
      end
    end
  end
end
