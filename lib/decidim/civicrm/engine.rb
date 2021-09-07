module Decidim
  module Civicrm
    # This is the engine that runs on the public interface of decidim-civicrm.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Civicrm

      initializer "decidim.civicrm.view_helpers" do
        ActionView::Base.include CivicrmHelper
      end
    end
  end
end
