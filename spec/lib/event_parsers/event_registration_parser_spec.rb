# frozen_string_literal: true

require "spec_helper"

describe Decidim::Civicrm::EventParsers::EventRegistrationParser, type: :class do
  subject { described_class.new(registration) }

  let(:registration) { create :registration }
  let(:organization) { meeting.organization }
  let(:meeting) { registration.meeting }
  let!(:authorization) { create :authorization, name: "civicrm", user: registration.user, metadata: { contact_id: contact_id } }
  let!(:event_meeting) { create :civicrm_event_meeting, organization: organization, meeting: meeting, civicrm_event_id: event_id }
  let(:contact_id) { 451 }
  let(:event_id) { 2345 }
  let(:json) do
    {
      event_id: event_id,
      contact_id: contact_id
    }
  end
  let(:data) do
    {
      entity: "Participant",
      action: "create",
      json: 1
    }
  end
  let(:result) do
    {
      "id" => "123"
    }
  end

  before do
    subject.result = result
  end

  it "is valid" do
    expect(subject.valid?).to eq(true)
  end

  it "returns data" do
    expect(subject.json).to eq(json)
    expect(subject.data).to eq(data.merge(json))
  end

  it "saves data" do
    expect { subject.save! }.to change(Decidim::Civicrm::EventRegistration, :count).by(1)
  end

  context "when no result" do
    let(:result) do
      {
        "id" => ""
      }
    end

    it "don't save data" do
      expect { subject.save! }.to raise_error ActiveRecord::RecordInvalid
      expect(Decidim::Civicrm::EventRegistration.count).to eq(0)
    end
  end

  context "when no contact_id" do
    let(:contact_id) { nil }

    it "is invalid" do
      expect(subject.valid?).to eq(false)
    end
  end
end
