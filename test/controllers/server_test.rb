require_relative '../test_helper'
class ServerTest < Minitest::Test
  include TestHelpers

  def test_server_receives_posts_to_random_path
    post '/foo'
    assert_equal 404, last_response.status
  end

  def test_server_receives_data_correctly_posted_to_sources
    post '/sources', {identifier: "jumpstartlab", root_url: "http://jumpstartlab.com"}
    assert_equal 200, last_response.status
    assert_equal "{'identifier':'jumpstartlab'}", last_response.body
  end

  def test_server_rejects_invalid_data
    post '/sources', {}
    assert_equal 400, last_response.status
    assert_equal "not a valid source", last_response.body
  end
end
