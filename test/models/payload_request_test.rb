require_relative '../test_helper'

class PayloadRequestTable < Minitest::Test
  include TestHelpers

  def payload
    payload = {
      "requested_at" => DateTime.now,
      "responded_in" => 37,
      "ip_id" => 4,
      "url_id" => 3,
      "referred_by_url_id" => 6,
      "user_agent_id" => 20,
      "screen_resolution_id" => 7,
      "request_type_id" => 1
    }
  end

  def create_payload_request
    PayloadRequest.create(payload)
  end

  def test_payload_request_object_has_attributes
    db_payload = create_payload_request
    payload.each do |key, value|
      assert_equal value, db_payload[key] unless key == "requested_at"
    end
  end

  def test_it_requires_all_fields
    PayloadRequest.create({"url_id" => 4})
    assert_equal 0, PayloadRequest.all.count

    create_payload_request
    assert_equal 1, PayloadRequest.all.count
  end
end
