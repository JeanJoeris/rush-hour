require_relative '../test_helper'

class IpsTest < Minitest::Test
  include TestHelpers

  def create_params
    params = {"address" => "192.168.0.1"}
    Ip.create(params)
  end

  def test_params_request_object_has_attributes
    db_params = create_params

    assert_equal "192.168.0.1", db_params["address"]
  end

  def test_it_requires_all_fields
    Ip.create({})
    assert_equal 0, Ip.all.count

    Ip.create({"address" => "192.168.0.1"})
    assert_equal 1, Ip.all.count
  end

  def test_ip_table_connects_to_payload_table
    ip = create_params

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

    assert_equal payload, ip.payload_requests.first
  end

end
