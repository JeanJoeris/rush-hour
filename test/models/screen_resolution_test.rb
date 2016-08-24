require_relative '../test_helper'

class ScreenResolutionsTest < Minitest::Test
  include TestHelpers

  def create_params
    params = {"height"=> "1280", "width"=> "960"}
    ScreenResolutions.create(params)
  end


  def test_params_request_object_has_attributes
    db_params = create_params

    assert_equal "1280", db_params["height"]
    assert_equal "960", db_params["width"]
  end

  def test_it_requires_all_fields
    ScreenResolutions.create({"height" => "1280"})
    assert_equal 0, ScreenResolutions.all.count

    ScreenResolutions.create({"height" => "1280", "width" => "960"})
    assert_equal 1, ScreenResolutions.all.count
  end

end
