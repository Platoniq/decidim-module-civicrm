# frozen_string_literal: true

module Decidim
  module Civicrm
    module Admin
      module CivicrmSyncHelpers
        def last_sync_class(datetime)
          return unless datetime

          return "alert" if datetime < 1.week.ago
          return "warning" if datetime < 1.day.ago

          "success"
        end
      end
    end
  end
end
