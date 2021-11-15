# frozen_string_literal: true

require "spec_helper"

module Decidim::Civicrm
  module Admin
    describe GroupsController, type: :controller do
      routes { Decidim::Civicrm::AdminEngine.routes }

      let(:organization) { create :organization }
      let(:user) { create(:user, :admin, :confirmed, organization: organization) }

      before do
        request.env["decidim.current_organization"] = organization
        sign_in user, scope: :user
      end

      context "when index" do
        it "shows a the sync button" do
          get :index

          expect(response).to render_template("decidim/civicrm/admin/groups/index")
        end
      end
    end
  end
end
