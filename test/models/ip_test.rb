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

    payload = PayloadRequest.create(get_payload_data)

    assert_equal payload, ip.payload_requests.first
  end

end
