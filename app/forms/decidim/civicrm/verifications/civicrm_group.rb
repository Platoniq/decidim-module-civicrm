# frozen_string_literal: true

require "digest"

module Decidim
  module Civicrm
    module Verifications
      class CivicrmGroup < CivicrmBasic
        validate :user_valid

        def unique_id
          Digest::SHA512.hexdigest(
            "#{uid}-civicrm-group-#{Rails.application.secrets.secret_key_base}"
          )
        end
      end
    end
  end
end
