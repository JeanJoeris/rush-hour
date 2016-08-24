require_relative '../test_helper'

class RequestTypesTest < Minitest::Test
  include TestHelpers

  def create_params
    params = {"http_verb" => "GET"}
    RequestTypes.create(params)
  end

  def test_params_request_object_has_attributes
    db_params = create_params

    assert_equal "GET", db_params["http_verb"]
  end

  def test_it_requires_all_fields
    RequestTypes.create({})
    assert_equal 0, RequestTypes.all.count

    RequestTypes.create({"http_verb" => "GET"})
    assert_equal 1, RequestTypes.all.count
  end

end
