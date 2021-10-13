# frozen_string_literal: true

shared_context "with stubs example api" do
  let(:url) { "https://api.example.org/" }
  let(:http_method) { :get }
  let(:http_status) { 200 }
  let(:data) do
    {
      "values" => [],
      "is_error" => 0,
      "version" => 3,
      "count" => 0
    }
  end
  let(:params) do
    {}
  end

  before do
    allow(Decidim::Civicrm::Api).to receive(:url).and_return(url)
    stub_request(http_method, /api\.example\.org/)
      .to_return(status: http_status, body: data.to_json, headers: {})
  end
end

shared_examples "returns hash content" do |key|
  it "returns a Hash with the result" do
    expect(subject.result).to be_a Hash
    expect(subject.result[key]).to be_a Array
    expect(subject.result[key]).to eq(data["values"].map(&:symbolize_keys))
  end
end

shared_examples "returns array content" do
  it "returns an Array with the result" do
    expect(subject.result).to be_a Array
    expect(subject.result).to eq(data["values"].map(&:symbolize_keys))
  end
end

shared_examples "returns a mapped property" do |key, property|
  it "returns a property mapped in an array" do
    expect(subject.result).to be_a Hash
    expect(subject.result[key]).to be_a Array
    expect(subject.result[key]).to eq(data["values"].map { |v| v[property] })
  end
end

shared_examples "returns a single object" do |key|
  it "returns a mapped object" do
    expect(subject.result).to be_a Hash
    expect(subject.result[key]).to eq(data["values"].first.symbolize_keys)
  end
end
