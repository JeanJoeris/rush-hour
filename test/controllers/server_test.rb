require_relative '../test_helper'
class ServerTest < Minitest::Test
  include TestHelpers

  def test_server_receives_posts_to_random_path
    post '/foo'
    assert_equal 404, last_response.status
  end

  def test_server_receives_data_correctly_posted_to_sources
    post '/sources', {identifier: "jumpstartlab", rootUrl: "http://jumpstartlab.com"}
    assert_equal 200, last_response.status
    assert_equal "{'identifier':'jumpstartlab'}", last_response.body
  end

  def test_server_rejects_invalid_data
    post '/sources', {client: {}}
    assert_equal 400, last_response.status
    assert_equal "not a valid client", last_response.body
  end

  def test_server_will_forbid_already_created_client
    post '/sources', {identifier: "jumpstartlab", rootUrl: "http://jumpstartlab.com"}
    post '/sources', {identifier: "jumpstartlab", rootUrl: "http://jumpstartlab.com"}
    assert_equal 403, last_response.status
    assert_equal "that is already a client", last_response.body
  end
end
