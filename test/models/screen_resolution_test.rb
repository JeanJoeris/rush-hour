require_relative '../test_helper'

class PayloadRequestTable < Minitest::Test
  include TestHelpers

  def create_payload
    {"height"=> "1280", "width"=> "960"}
  end


  def test_payload_request_object_has_attributes
    db_payload = create_payload

    assert_equal "1280", db_payload["height"]
    assert_equal "960", db_payload["width"]
  end



end
