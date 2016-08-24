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
    user_agent = UserAgent.create( "os"=>"Intel Mac OS X 10_8_2", "browser"=> "Chrome/24.0.1309.0" )
    payload = create_payload_request
    assert_equal user_agent, payload.user_agent
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



end
