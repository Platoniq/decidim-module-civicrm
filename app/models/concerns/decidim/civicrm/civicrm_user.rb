# frozen_string_literal: true

module Decidim
  module Civicrm
    module CivicrmUser
      extend ActiveSupport::Concern

      included do
        has_one :contact, class_name: "Decidim::Civicrm::Contact", foreign_key: "decidim_user_id", dependent: :destroy

        def civicrm_identity?
          identities.exists?(provider: Decidim::Civicrm::PROVIDER_NAME)
        end
      end
    end
  end
end
