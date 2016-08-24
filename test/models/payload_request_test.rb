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
      "user_agent_id" => 1,
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
end
