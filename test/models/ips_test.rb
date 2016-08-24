require_relative '../test_helper'

class IpsTest < Minitest::Test
  include TestHelpers

  def create_params
    params = {"address" => "192.168.0.1"}
    Ips.create(params)
  end

  def test_params_request_object_has_attributes
    db_params = create_params

    assert_equal "192.168.0.1", db_params["address"]
  end

  def test_it_requires_all_fields
    Ips.create({})
    assert_equal 0, Ips.all.count

    Ips.create({"address" => "192.168.0.1"})
    assert_equal 1, Ips.all.count
  end

end
