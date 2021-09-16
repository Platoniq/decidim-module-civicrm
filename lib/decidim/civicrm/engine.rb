# frozen_string_literal: true

module Decidim
  module Civicrm
    # This is the engine that runs on the public interface of decidim-civicrm.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Civicrm

      # Prepare a zone to create overrides
      # https://edgeguides.rubyonrails.org/engines.html#overriding-models-and-controllers
      # overrides
      config.to_prepare do
        Decidim::User.include(Decidim::Civicrm::CivicrmUser)
      end

      routes do
        root to: "authorizations#new"
      end
    end
  end
end
