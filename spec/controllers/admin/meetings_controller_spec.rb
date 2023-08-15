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
          event_meeting: {
            decidim_meeting_id: decidim_meeting_id,
            redirect_url: url,
            redirect_active: active
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

      describe "GET index" do
        let!(:event1) { create :civicrm_event_meeting, :minimal, organization: organization }
        let!(:event2) { create :civicrm_event_meeting, :minimal, organization: organization }
        let!(:event3) { create :civicrm_event_meeting, :minimal }

        it "renders the index template" do
          get :index

          expect(response).to render_template("decidim/civicrm/admin/meetings/index")
        end

        it "returns list of meetings in json format" do
          get :index, format: :json

          expect(response).not_to render_template("decidim/civicrm/admin/meetings/index")
          parsed = JSON.parse(response.body)
          expect(parsed.pluck("civicrm_event_id")).to include event1.civicrm_event_id
          expect(parsed.pluck("civicrm_event_id")).to include event2.civicrm_event_id
          expect(parsed.pluck("civicrm_event_id")).not_to include event3.civicrm_event_id
        end
      end

      context "when creating a event meeting" do
        it "creates redirects back" do
          post :create, params: params

          expect(response).to redirect_to("/admin/civicrm/meetings")
        end

        it "returns list of meetings in json format" do
          get :index, format: :json

        it "creates a new event meeting" do
          expect { post(:create, params: params) }.to change(EventMeeting, :count).by(1)
        end

        context "and meeting does not exist" do
          let(:decidim_meeting_id) { nil }

          it "do not create a new event meeting" do
            expect { post(:create, params: params) }.not_to change(EventMeeting, :count)
          end
        end
      end

      context "when destroying a event meeting" do
        let!(:event_meeting) { create :civicrm_event_meeting, organization: organization, meeting: meeting, civicrm_event_id: civicrm_event_id }
        let(:civicrm_event_id) { nil }

        it "destroys the event" do
          expect { delete :destroy, params: { id: event_meeting.id } }.to change(EventMeeting, :count).by(-1)
        end

        context "when not removable" do
          let(:civicrm_event_id) { 123 }

          it "do not destroy the event" do
            expect { delete :destroy, params: { id: event_meeting.id } }.to raise_exception(ActiveRecord::RecordNotDestroyed)

            expect(EventMeeting.count).to eq(1)
          end
        end
      end

      context "when toggle redirect_active to active" do
        let!(:event_meeting) { create :civicrm_event_meeting, organization: organization, meeting: meeting, redirect_active: active }
        let(:active) { false }

        it "toggles" do
          put :toggle_active, params: { id: event_meeting.id }

          expect(event_meeting.reload.redirect_active).to be(true)

          put :toggle_active, params: { id: event_meeting.id }

          expect(event_meeting.reload.redirect_active).to be(false)
        end
      end
    end
  end
end
