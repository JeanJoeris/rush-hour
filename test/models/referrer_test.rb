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

    payload = PayloadRequest.create(get_payload_data)

    assert_equal payload, referrer.payload_requests.first
  end

end
