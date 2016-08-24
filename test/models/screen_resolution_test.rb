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

    payload_params =
    {
      "requested_at" => DateTime.now,
      "responded_in" => 37,
      "ip_id" => 1,
      "url_id" => 1,
      "referrer_id" => 1,
      "user_agent_id" => 1,
      "screen_resolution_id" => 1,
      "request_type_id" => 1
    }

    payload = PayloadRequest.create(payload_params)

    assert_equal payload, screen_resolution.payload_requests.first
  end

end
