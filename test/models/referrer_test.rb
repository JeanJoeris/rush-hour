require_relative '../test_helper'

class ReferrersTest < Minitest::Test
  include TestHelpers

  def create_params
    params = {"name" => "Google"}
    Referrer.create(params)
  end

  def test_params_request_object_has_attributes
    db_params = create_params

    assert_equal "Google", db_params["name"]
  end

  def test_it_requires_all_fields
    Referrer.create({})
    assert_equal 0, Referrer.all.count

    create_params
    assert_equal 1, Referrer.all.count
  end

  def test_referrer_table_connects_to_payload_table
    referrer = create_params

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

    assert_equal payload, referrer.payload_requests.first
  end

end
