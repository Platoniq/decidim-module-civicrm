# frozen_string_literal: true

require "spec_helper"

describe Decidim::Civicrm::Verifications::InvalidNotification do
  include_context "when a simple event"

  let(:event_name) { "decidim.events.civicrm_verification.invalid" }
  let(:resource) { create :user }

  it_behaves_like "a simple event", true
end
