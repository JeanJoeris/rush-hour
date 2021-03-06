require_relative '../test_helper'

class UserAgentsTable < Minitest::Test
  include TestHelpers

  def create_params
    params = {"os"=>"Intel Mac OS X 10_8_2", "browser"=> "Chrome/24.0.1309.0"}
    Agent.create(params)
  end

  def test_params_request_object_has_attributes
    db_params = create_params

    assert_equal "Intel Mac OS X 10_8_2", db_params["os"]
    assert_equal "Chrome/24.0.1309.0", db_params["browser"]
  end

  def test_only_valid_entries_are_entered
    Agent.create({})
    assert_equal 0, Agent.all.count

    Agent.create({"os"=>"Intel Mac OS X 10_8_2", "browser"=> "Chrome/24.0.1309.0"})
    assert_equal 1, Agent.all.count
  end

  def test_agent_table_connects_to_payload_table
    user_agent = create_params

    payload = PayloadRequest.create(get_payload_data)

    assert_equal payload, user_agent.payload_requests.first
  end

end
