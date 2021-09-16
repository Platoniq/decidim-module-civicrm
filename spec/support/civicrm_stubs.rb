# frozen_string_literal: true

module CivicrmStubs
  def yaml
    @yaml ||= YAML.safe_load(File.read(file_fixture("stubs.yml"))).deep_symbolize_keys
  end

  def stub_api_request(request_name, valid: true)
    request = yaml[request_name]

    url = request[:url]
    file = valid ? request[:json] : yaml[:error][:json]

    stub_request_for(url, file_fixture(file))
  end

  private

  # This will change depending on your gems versions.
  def headers
    {
      "Accept" => "*/*",
      "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3"
    }
  end

  def stub_request_for(url, body)
    stub_request(:get, url)
      .with(
        headers: headers
      ).to_return(
        status: 200,
        body: body,
        headers: {}
      )
  end
end
