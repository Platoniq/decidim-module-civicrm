# frozen_string_literal: true

module Decidim
  module Civicrm
    module Generators
      class InstallGenerator < Rails::Generators::Base
        source_root File.expand_path("templates", __dir__)

        desc "Adds initializer files and install migrations for CiViCRM OAuth and verifications."

        def copy_files
          copy_file "omniauth_civicrm.rb", "config/initializers/omniauth_civicrm.rb"
          copy_file "civicrm_verification.rb", "config/initializers/civicrm_verification.rb"

          rake "decidim_civicrm:install:migrations"
          rake "db:migrate"
        end
      end
    end
  end
end
