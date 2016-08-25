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
      "agent_id" => 1,
      "screen_resolution_id" => 1,
      "request_type_id" => 1
    }

    payload = PayloadRequest.create(payload_params)

    assert_equal payload, url.payload_requests.first
  end

  def test_that_min_response_time_of_payload_requests_is_calculated
    payload_data_1 = get_payload_data
    payload_data_1["responded_in"] = 10
    payload_data_1["url_id"] = 2
    payload_data_2 = get_payload_data
    payload_data_2["responded_in"] = 20
    payload_data_2["url_id"] = 2
    payload_data_3 = get_payload_data
    payload_data_3["responded_in"] = 30
    payload_data_3["url_id"] = 2

    PayloadRequest.create(payload_data_1)
    PayloadRequest.create(payload_data_2)
    PayloadRequest.create(payload_data_3)

    params = {"url_path"=>"http://www.google.com"}

    url_data_1 = create_params
    url_data_2 = create_params

    assert_equal 10, url_data_2.min_response_time
  end

  
end
