# frozen_string_literal: true

module Decidim
  module Civicrm
    # This is the engine that runs on the admin interface of decidim-civicrm.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::Civicrm::Admin

      paths["db/migrate"] = nil
      paths["lib/tasks"] = nil

      routes do
        resources :groups, only: [:index, :show] do
          collection do
            get :sync
          end
        end

        resources :membership_types, only: [:index] do
          collection do
            get :sync
          end
        end

        root to: "groups#index"
      end

      initializer "decidim.civicrm.mount_admin_engine" do
        Decidim::Core::Engine.routes do
          mount Decidim::Civicrm::AdminEngine, at: "/admin/civicrm", as: "decidim_civicrm_admin"
        end
      end

      initializer "decidim.civicrm.admin_menu" do
        Decidim.menu :admin_menu do |menu|
          menu.item I18n.t("menu.civicrm", scope: "decidim.admin", default: "CiViCRM"),
                    decidim_civicrm_admin.groups_path,
                    icon_name: "people",
                    position: 5.75,
                    active: is_active_link?(decidim_civicrm_admin.groups_path, :inclusive),
                    if: defined?(current_user) && current_user&.read_attribute("admin")
        end
      end

      def load_seed
        nil
      end
    end
  end
end
