require_relative '../test_helper'

class IpsTest < Minitest::Test
  include TestHelpers

  def create_payload
    {"address" => "192.168.0.1"}
  end

  def test_payload_request_object_has_attributes
    db_payload = create_payload

    assert_equal "192.168.0.1", db_payload["address"]
  end

end
