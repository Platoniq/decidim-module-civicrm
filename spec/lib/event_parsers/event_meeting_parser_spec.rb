# frozen_string_literal: true

require "spec_helper"

describe Decidim::Civicrm::EventParsers::EventMeetingParser, type: :class do
  subject { described_class.new(meeting) }

  let(:meeting) { create :meeting }
  let(:json) do
    {
      start_date: meeting.start_time.strftime("%Y%m%d"),
      end_date: meeting.end_time.strftime("%Y%m%d"),
      title: "#{meeting.participatory_space.title["ca"]}: #{meeting.title["ca"]}",
      template_id: 2
    }
  end
  let(:data) do
    {
      entity: "Event",
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
    expect { subject.save! }.to change(Decidim::Civicrm::EventMeeting, :count).by(1)
  end

  context "when no result" do
    let(:result) do
      {
        "id" => ""
      }
    end

    it "don't save data" do
      expect { subject.save! }.to raise_error ActiveRecord::RecordInvalid
      expect(Decidim::Civicrm::EventMeeting.count).to eq(0)
    end
  end
end