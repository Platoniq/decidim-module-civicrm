# frozen_string_literal: true

require "decidim/civicrm/admin"
require "decidim/civicrm/admin_engine"
require "decidim/civicrm/api"
require "decidim/civicrm/engine"
require "decidim/civicrm/verifications"
require "decidim/civicrm/version"
require "decidim/civicrm/workflows"

module Decidim
  # This namespace holds the logic of the `decidim-civicrm` module.
  module Civicrm
    class Error < StandardError; end
  end
end
