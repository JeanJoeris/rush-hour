require_relative '../test_helper'

class PayloadRequestTest < Minitest::Test
  include TestHelpers

  def payload
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
  end

  def create_payload_request(data = payload)
    PayloadRequest.create(data)
  end

  def test_payload_request_object_has_attributes
    db_payload = create_payload_request

    assert_equal 1, db_payload["url_id"]
    assert_equal 1, db_payload["request_type_id"]
    assert_equal 1, db_payload["ip_id"]
  end

  def test_it_requires_all_fields
    PayloadRequest.create({"url_id" => 4})
    assert_equal 0, PayloadRequest.all.count

    create_payload_request
    assert_equal 1, PayloadRequest.all.count
  end

  def test_that_payload_requests_connects_to_ip_table
    ip = Ip.create( address: "192.32.64.64" )
    payload = create_payload_request
    assert_equal ip, payload.ip
  end

  def test_that_payload_requests_connects_to_url_table
    url = Url.create( "url_path"=>"http://www.google.com" )
    payload = create_payload_request
    assert_equal url, payload.url
  end

  def test_that_payload_requests_connects_to_referrer_table
    referrer = Referrer.create( "name" => "http://www.google.com" )
    payload = create_payload_request
    assert_equal referrer, payload.referrer
  end

  def test_that_payload_requests_connects_to_user_agent_table
    agent = Agent.create( "os"=>"Intel Mac OS X 10_8_2", "browser"=> "Chrome/24.0.1309.0" )
    payload = create_payload_request
    assert_equal agent, payload.agent
  end

  def test_that_payload_requests_connects_to_screen_resolution_table
    screen_resolution = ScreenResolution.create( "height"=> "1280", "width"=> "960" )
    payload = create_payload_request
    assert_equal screen_resolution, payload.screen_resolution
  end

  def test_that_payload_requests_connects_to_request_type_table
    request_type = RequestType.create( "http_verb" => "GET" )
    payload = create_payload_request
    assert_equal request_type, payload.request_type
  end

  def test_that_it_calculates_the_average_response_time
    payload_data_1 = get_payload_data
    payload_data_1["responded_in"] = 10
    payload_data_2 = get_payload_data
    payload_data_2["responded_in"] = 20
    payload_data_3 = get_payload_data
    payload_data_3["responded_in"] = 30

    PayloadRequest.create(payload_data_1)
    PayloadRequest.create(payload_data_2)
    PayloadRequest.create(payload_data_3)

    assert_equal 20, PayloadRequest.average_response_time
  end

  def test_that_min_calculates_the_minimum_response_time
    payload_data_1 = get_payload_data
    payload_data_1["responded_in"] = 10
    payload_data_2 = get_payload_data
    payload_data_2["responded_in"] = 20
    payload_data_3 = get_payload_data
    payload_data_3["responded_in"] = 30

    PayloadRequest.create(payload_data_1)
    PayloadRequest.create(payload_data_2)
    PayloadRequest.create(payload_data_3)

    assert_equal 10, PayloadRequest.min_response_time
  end

  def test_that_max_calculates_the_maximum_response_time
    payload_data_1 = get_payload_data
    payload_data_1["responded_in"] = 10
    payload_data_2 = get_payload_data
    payload_data_2["responded_in"] = 20
    payload_data_3 = get_payload_data
    payload_data_3["responded_in"] = 30

    PayloadRequest.create(payload_data_1)
    PayloadRequest.create(payload_data_2)
    PayloadRequest.create(payload_data_3)

    assert_equal 30, PayloadRequest.max_response_time
  end

  def test_find_most_used_reqest_type_with_most_used_request_type_method
    populate_request_types_table

    payload_data_1 = get_payload_data
    payload_data_1["request_type_id"] = 1
    payload_data_2 = get_payload_data
    payload_data_2["request_type_id"] = 2
    payload_data_3 = get_payload_data
    payload_data_3["request_type_id"] = 3

    PayloadRequest.create(payload_data_1)
    PayloadRequest.create(payload_data_1)
    PayloadRequest.create(payload_data_2)
    assert_equal "GET", PayloadRequest.most_used_request_type

    PayloadRequest.create(payload_data_3)
    PayloadRequest.create(payload_data_3)
    PayloadRequest.create(payload_data_3)
    PayloadRequest.create(payload_data_3)
    assert_equal "PUT", PayloadRequest.most_used_request_type
  end

  def test_it_finds_all_http_verbs
    populate_request_types_table

    payload_data_1 = get_payload_data
    payload_data_1["request_type_id"] = 1
    payload_data_2 = get_payload_data
    payload_data_2["request_type_id"] = 5
    payload_data_3 = get_payload_data
    payload_data_3["request_type_id"] = 3

    PayloadRequest.create(payload_data_1)
    PayloadRequest.create(payload_data_2)
    PayloadRequest.create(payload_data_3)

    assert_equal ["GET", "DELETE", "PUT"], PayloadRequest.all_http_verbs
  end

  def test_ordered_urls_from_most_requested_to_least
    populate_url_table

    payload_data_1 = get_payload_data
    payload_data_1["url_id"] = 1
    payload_data_2 = get_payload_data
    payload_data_2["url_id"] = 2
    payload_data_3 = get_payload_data
    payload_data_3["url_id"] = 3

    PayloadRequest.create(payload_data_1)
    PayloadRequest.create(payload_data_2)
    PayloadRequest.create(payload_data_2)
    PayloadRequest.create(payload_data_3)
    assert_equal ["http://www.reddit.com", "http://www.google.com", "http://www.yahoo.com"], PayloadRequest.ordered_url_paths
  end

  def test_browser_breakdown_find_all_browsers_with_count
    populate_agent_table

    payload_data_1 = get_payload_data
    payload_data_1["agent_id"] = 1
    payload_data_2 = get_payload_data
    payload_data_2["agent_id"] = 2
    payload_data_3 = get_payload_data
    payload_data_3["agent_id"] = 3

    PayloadRequest.create(payload_data_1)
    PayloadRequest.create(payload_data_2)
    PayloadRequest.create(payload_data_3)
    PayloadRequest.create(payload_data_3)

    assert_equal ["IEewwwww: 2", "Firefox: 1", "Chrome: 1"], PayloadRequest.browser_breakdown
  end

  def test_os_breakdown_find_all_browsers_with_count
    populate_agent_table

    payload_data_1 = get_payload_data
    payload_data_1["agent_id"] = 1
    payload_data_2 = get_payload_data
    payload_data_2["agent_id"] = 2
    payload_data_3 = get_payload_data
    payload_data_3["agent_id"] = 3

    PayloadRequest.create(payload_data_1)
    PayloadRequest.create(payload_data_2)
    PayloadRequest.create(payload_data_3)
    PayloadRequest.create(payload_data_3)

    assert_equal ["Microsoft Windows 10: 2", "Intel Mac OS X 10_8_2: 1", "Intel Mac OS X 10_8_2: 1"], PayloadRequest.os_breakdown
  end

  def test_get_screen_resolution_with_width_and_height
    populate_screen_resoultion_table

    payload_data_1 = get_payload_data
    payload_data_1["screen_resolution_id"] = 1
    payload_data_2 = get_payload_data
    payload_data_2["screen_resolution_id"] = 2
    payload_data_3 = get_payload_data
    payload_data_3["screen_resolution_id"] = 3

    PayloadRequest.create(payload_data_1)
    PayloadRequest.create(payload_data_2)
    PayloadRequest.create(payload_data_2)
    PayloadRequest.create(payload_data_3)

    assert_equal "", PayloadRequest.get_screen_resolution
  end
end
