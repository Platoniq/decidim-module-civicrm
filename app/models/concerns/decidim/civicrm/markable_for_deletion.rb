# frozen_string_literal: true

require "active_support/concern"

module Decidim
  module Civicrm
    module MarkableForDeletion
      extend ActiveSupport::Concern

      class_methods do
        def self.prepare_cleanup
          update_all(marked_for_deletion: true)
        end

        def self.clean_up_records
          where(marked_for_deletion: true).destroy_all
        end
      end
    end
  end
end
