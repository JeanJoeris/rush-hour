require_relative '../test_helper'

class PayloadRequestTable < Minitest::Test
  include TestHelpers

  def create_payload
    {"os"=>"Intel Mac OS X 10_8_2", "browser"=> "Chrome/24.0.1309.0"}
  end

  def test_payload_request_object_has_attributes
    db_payload = create_payload

    assert_equal "Intel Mac OS X 10_8_2", db_payload["os"]
    assert_equal "Chrome/24.0.1309.0", db_payload["browser"]
  end
end
