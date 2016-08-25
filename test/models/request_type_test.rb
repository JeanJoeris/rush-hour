require_relative '../test_helper'

class RequestTypesTest < Minitest::Test
  include TestHelpers

  def create_params
    params = {"http_verb" => "GET"}
    RequestType.create(params)
  end

  def test_params_request_object_has_attributes
    db_params = create_params

    assert_equal "GET", db_params["http_verb"]
  end

  def test_it_requires_all_fields
    RequestType.create({})
    assert_equal 0, RequestType.all.count

    RequestType.create({"http_verb" => "GET"})
    assert_equal 1, RequestType.all.count
  end

  def test_request_type_table_connects_to_payload_table
    request_type = create_params

    payload = PayloadRequest.create(get_payload_data)

    assert_equal payload, request_type.payload_requests.first
  end

end
