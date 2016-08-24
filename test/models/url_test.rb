require_relative '../test_helper'

class UrlsTest < Minitest::Test
  include TestHelpers

  def create_params
    params = {"url_path"=>"http://www.google.com"}
    Url.create(params)
  end

  def test_params_request_object_has_attributes
    db_params = create_params

    assert_equal "http://www.google.com", db_params["url_path"]
  end

  def test_it_requires_all_fields
    Url.create({})
    assert_equal 0, Url.all.count

    Url.create({"url_path"=>"http://www.google.com"})
    assert_equal 1, Url.all.count
  end

  def test_url_table_connects_to_payload_table
    url = create_params

    payload_params =
    {
      "requested_at" => DateTime.now,
      "responded_in" => 37,
      "ip_id" => 1,
      "url_id" => 1,
      "referrer_id" => 1,
      "user_agent_id" => 1,
      "screen_resolution_id" => 1,
      "request_type_id" => 1
    }

    payload = PayloadRequest.create(payload_params)

    assert_equal payload, url.payload_requests.first
  end

end
