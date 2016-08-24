require_relative '../test_helper'

class UserAgentsTable < Minitest::Test
  include TestHelpers

  def create_params
    params = {"os"=>"Intel Mac OS X 10_8_2", "browser"=> "Chrome/24.0.1309.0"}
    UserAgents.create(params)
  end

  def test_params_request_object_has_attributes
    db_params = create_params

    assert_equal "Intel Mac OS X 10_8_2", db_params["os"]
    assert_equal "Chrome/24.0.1309.0", db_params["browser"]
  end

  def test_only_valid_entries_are_entered
    UserAgents.create({})
    assert_equal 0, UserAgents.all.count

    UserAgents.create({"os"=>"Intel Mac OS X 10_8_2", "browser"=> "Chrome/24.0.1309.0"})
    assert_equal 1, UserAgents.all.count
  end
end
