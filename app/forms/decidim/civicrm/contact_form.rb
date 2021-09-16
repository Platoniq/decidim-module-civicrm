# frozen_string_literal: true

module Decidim
  module Civicrm
    class ContactForm < Decidim::Form
      attribute :decidim_user_id, Integer
      attribute :decidim_organization_id, Integer
      attribute :civicrm_contact_id, Integer
      attribute :extra, Hash
    end
  end
end
