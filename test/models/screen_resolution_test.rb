require_relative '../test_helper'

class ScreenResolutionsTest < Minitest::Test
  include TestHelpers

  def create_params
    params = {"height"=> "1280", "width"=> "960"}
    ScreenResolution.create(params)
  end


  def test_params_request_object_has_attributes
    db_params = create_params

    assert_equal "1280", db_params["height"]
    assert_equal "960", db_params["width"]
  end

  def test_it_requires_all_fields
    ScreenResolution.create({"height" => "1280"})
    assert_equal 0, ScreenResolution.all.count

    ScreenResolution.create({"height" => "1280", "width" => "960"})
    assert_equal 1, ScreenResolution.all.count
  end

  def test_screen_resolution_table_connects_to_payload_table
    screen_resolution = create_params

    payload = PayloadRequest.create(get_payload_data)

    assert_equal payload, screen_resolution.payload_requests.first
  end

end
