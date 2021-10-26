# frozen_string_literal: true

require "spec_helper"

module Decidim::Meetings
  describe RegistrationsController, type: :controller do
    routes { Decidim::Meetings::Engine.routes }

    let!(:meeting) { create :meeting, :with_registrations_enabled }
    let!(:meeting_redirection) { create :civicrm_meeting_redirection, meeting: meeting, organization: organization, active: active }
    let!(:user) { create(:user, :confirmed, organization: organization) }
    let(:organization) { meeting.organization }
    let(:component) { meeting.component }
    let(:active) { true }

    let(:params) do
      {
        meeting_id: meeting.id,
        component_id: component.id
      }
    end

    before do
      request.env["decidim.current_organization"] = organization
      request.env["decidim.current_participatory_space"] = component.participatory_space
      request.env["decidim.current_component"] = component
      sign_in user, scope: :user
    end

    context "when redirection exists" do
      it "redirects to external url" do
        post :create, params: params

        expect(response).to redirect_to(meeting_redirection.url)
      end
    end

    context "when redirection does not exists" do
      let(:meeting_redirection) { create :civicrm_meeting_redirection, organization: organization, meeting: another_meeting }
      let(:another_meeting) { create :meeting, component: component }

      it "redirects redirects to meeting" do
        post :create, params: params

        expect(response).to redirect_to(space_path.meeting_path(meeting))
      end
    end

    context "when redirection is inactive" do
      let(:active) { false }

      it "redirects redirects to meeting" do
        post :create, params: params

        expect(response).to redirect_to(space_path.meeting_path(meeting))
      end
    end

    def space_path
      Decidim::EngineRouter.main_proxy(component)
    end
  end
end
