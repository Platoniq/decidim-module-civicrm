# frozen_string_literal: true

require "active_support/concern"

module Decidim
  module Civicrm
    module MarkableForDeletion
      extend ActiveSupport::Concern

      included do
        scope :to_delete, -> { where(marked_for_deletion: true) }
        scope :to_keep, -> { where(marked_for_deletion: false) }
      end

      class_methods do
        # rubocop:disable Rails/SkipsModelValidations

        def prepare_cleanup(query = {})
          where(query).update_all(marked_for_deletion: true)
        end

        def clean_up_records(query = {})
          where(query).to_delete.destroy_all
        end

        # rubocop:enable Rails/SkipsModelValidations
      end
    end
  end
end
