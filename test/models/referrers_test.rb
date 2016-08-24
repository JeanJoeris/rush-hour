require_relative '../test_helper'

class ReferrersTest < Minitest::Test
  include TestHelpers

  def create_params
    params = {"name" => "Google"}
    Referrers.create(params)
  end

  def test_params_request_object_has_attributes
    db_params = create_params

    assert_equal "Google", db_params["name"]
  end

  def test_it_requires_all_fields
    Referrers.create({})
    assert_equal 0, Referrers.all.count

    create_params
    assert_equal 1, Referrers.all.count
  end

end
