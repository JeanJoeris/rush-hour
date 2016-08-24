require_relative '../test_helper'

class PayloadRequestTable < Minitest::Test
  include TestHelpers

  def create_payload
    {"http_verb" => "GET"}
  end

  def test_payload_request_object_has_attributes
    db_payload = create_payload

    assert_equal "GET", db_payload["http_verb"]
  end

end
