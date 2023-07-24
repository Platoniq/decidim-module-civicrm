# frozen_string_literal: true

module Decidim
  describe Civicrm do
    it "has a version number" do
      expect(Decidim::Civicrm::VERSION).not_to be_nil
      expect(Decidim::Civicrm::DECIDIM_VERSION).not_to be_nil
      expect(Decidim::Civicrm::COMPAT_DECIDIM_VERSION).not_to be_nil
    end
  end
end
