require_relative '../test_helper'

class PayloadRequestTable < Minitest::Test
  include TestHelpers

  def create_payload
    {"url_path"=>"http://www.google.com"}
  end

  def test_payload_request_object_has_attributes
    db_payload = create_payload

    assert_equal "http://www.google.com", db_payload["url_path"]
  end

end
