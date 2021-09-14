# frozen_string_literal: true

module CivicrmStubs
  ## User
  def stub_user_valid_request
    stub_request_for(user_request_url, file_fixture("user_valid_response.json"))
  end

  def stub_user_not_found_request
    stub_request_for(user_request_url, file_fixture("empty_response.json"))
  end

  def stub_user_invalid_request
    stub_request_for(user_request_url, file_fixture("error_response.json"))
  end

  ## Contact
  def stub_contact_valid_request
    stub_request_for(contact_request_url, file_fixture("contact_valid_response.json"))
  end

  ## Group
  def stub_group_valid_request
    stub_request_for(group_request_url, file_fixture("group_valid_response.json"))
  end

  def stub_group_invalid_request
    stub_request_for(group_request_url, file_fixture("error_response.json"))
  end

  ## Groups
  def stub_groups_valid_request
    stub_request_for(groups_request_url, file_fixture("groups_valid_response.json"))
  end

  def stub_groups_invalid_request
    stub_request_for(groups_request_url, file_fixture("error_response.json"))
  end

  ## Users in group
  def stub_contacts_in_group_valid_request
    stub_request_for(contacts_in_group_request_url, file_fixture("contacts_in_group_valid_response.json"))
  end

  def stub_contacts_in_group_invalid_request
    stub_request_for(contacts_in_group_request_url, file_fixture("error_response.json"))
  end

  private

  def user_request_url
    "https://api.base/?action=Get&api_key=fake-civicrm-api-key&entity=User&id=42&json=%7B%22api.Contact.get%22%3A%7B%22return%22%3A%22display_name%22%7D%2C%22sequential%22%3A1%7D&key=fake-civicrm-api-secret"
  end

  def contact_request_url
    "https://api.base/?action=Get&api_key=fake-civicrm-api-key&entity=Contact&contact_id=42&json=%7B%22return%22%3A%22display_name%22%2C%22sequential%22%3A1%7D&key=fake-civicrm-api-secret"
  end

  def group_request_url
    "https://api.base/?action=Get&api_key=fake-civicrm-api-key&entity=Group&group_id=1&json=%7B%22return%22%3A%22group_id%2Cname%2Ctitle%2Cdescription%2Cgroup_type%22%2C%22sequential%22%3A1%7D&key=fake-civicrm-api-secret"
  end

  def groups_request_url
    "https://api.base/?action=Get&api_key=fake-civicrm-api-key&entity=Group&is_active=1&json=%7B%22options%22%3A%7B%22limit%22%3A0%7D%2C%22return%22%3A%22group_id%2Cname%2Ctitle%2Cdescription%2Cgroup_type%22%2C%22sequential%22%3A1%7D&key=fake-civicrm-api-secret"
  end

  def contacts_in_group_request_url
    "https://api.base/?action=Get&api_key=fake-civicrm-api-key&entity=Contact&group=1&json=%7B%22options%22%3A%7B%22limit%22%3A0%7D%2C%22return%22%3A%22contact_id%22%2C%22sequential%22%3A1%7D&key=fake-civicrm-api-secret"
  end

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
