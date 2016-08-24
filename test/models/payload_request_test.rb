require_relative '../test_helper'

class PayloadRequestTable < Minitest::Test
  include TestHelpers

  def create_payload_request
    payload = {
      "requested_at" => DateTime.now,
      "responded_in" => 37,
      "ip_id" => 4,
      "url_id" => 3,
      "referrer_id" => 6,
      "user_agent_id" => 20,
      "screen_resolution_id" => 7,
      "request_type_id" => 1
    }
    PayloadRequest.create(payload)
  end

  def test_payload_request_object_has_attributes
    db_payload = create_payload_request

    assert_equal 3, db_payload["url_id"]
    assert_equal 1, db_payload["request_type_id"]
    assert_equal 4, db_payload["ip_id"]
  end

  def test_it_requires_all_fields
    PayloadRequest.create({"url_id" => 4})
    assert_equal 0, PayloadRequest.all.count

    create_payload_request
    assert_equal 1, PayloadRequest.all.count
  end
end
