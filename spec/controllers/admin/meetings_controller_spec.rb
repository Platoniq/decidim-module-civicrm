# frozen_string_literal: true

require "spec_helper"

module Decidim::Civicrm
  module Admin
    describe MeetingsController, type: :controller do
      routes { Decidim::Civicrm::AdminEngine.routes }

      let(:organization) { create :organization }
      let(:user) { create(:user, :admin, :confirmed, organization: organization) }

      let(:params) do
        {
          meeting_redirection: {
            decidim_meeting_id: decidim_meeting_id,
            url: url,
            active: active
          }
        }.with_indifferent_access
      end

      let(:meeting) { create :meeting }
      let(:decidim_meeting_id) { meeting.id }
      let(:url) { ::Faker::Internet.url }
      let(:active) { true }

      before do
        request.env["decidim.current_organization"] = organization
        sign_in user, scope: :user
      end

      context "when creating a meeting redirection" do
        it "creates redirects back" do
          post :create, params: params

          expect(response).to redirect_to(meetings_path)
        end

        it "creates a new meeting redirection" do
          expect { post(:create, params: params) }.to change(MeetingRedirection, :count).by(1)
        end

        context "and meeting does not exist" do
          let(:decidim_meeting_id) { nil }

          it "do not create a new meeting redirection" do
            expect { post(:create, params: params) }.to change(MeetingRedirection, :count).by(0)
          end
        end
      end
    end
  end
end
