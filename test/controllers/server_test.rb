require_relative '../test_helper'
class ServerTest < Minitest::Test
  include TestHelpers

  def json_payload
    '{"url":"http://jumpstartlab.com/blog",
      "requestedAt":"2013-02-16 21:38:28 -0700",
      "respondedIn":37,
      "referredBy":"http://jumpstartlab.com",
      "requestType":"GET",
      "userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
      "resolutionWidth":"1920",
      "resolutionHeight":"1280",
      "ip":"63.29.38.211"}'
  end

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

  def test_server_post_to_client_will_will_create_payload_request
    client = Client.create(identifier: "jumpstartlab", root_url: "http://jumpstartlab.com")
    post "/sources/#{client.identifier}/data", { payload: json_payload }
    assert_equal 200, last_response.status
    assert_equal 1, PayloadRequest.all.count
  end

  def test_post_to_client_will_recognize_bad_request_400
    client = Client.create(identifier: "jumpstartlab", root_url: "http://jumpstartlab.com")
    payload=  '{"url":"http://jumpstartlab.com/blog",
              "requestedAt":"2013-02-16 21:38:28 -0700",
              "respondedIn":37,
              "referredBy":"http://jumpstartlab.com",
              "requestType":"GET",
              "userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17"
              }'
    post "/sources/#{client.identifier}/data", { payload: payload }
    assert_equal 400, last_response.status
    assert_equal "No payload request found", last_response.body
    assert_equal 0, PayloadRequest.all.count
  end

  def test_post_to_client_responds_with_403_error
    client = Client.create(identifier: "jumpstartlab", root_url: "http://jumpstartlab.com")
    post "/sources/#{client.identifier}/data", { payload: json_payload }
    post "/sources/#{client.identifier}/data", { payload: json_payload }
    assert_equal 403, last_response.status
    assert_equal "This is already entered", last_response.body
  end

  def test_post_to_client_with_post_differing_only_in_requested_at_different_suceeds
    client = Client.create(identifier: "jumpstartlab", root_url: "http://jumpstartlab.com")
    different_date_json =  '{"url":"http://jumpstartlab.com/blog",
              "requestedAt":"2014-03-16 21:35:28 -0700",
              "respondedIn":37,
              "referredBy":"http://jumpstartlab.com",
              "requestType":"GET",
              "userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
              "resolutionWidth":"1920",
              "resolutionHeight":"1280",
              "ip":"63.29.38.211"}'
    post "/sources/#{client.identifier}/data", { payload: json_payload }
    post "/sources/#{client.identifier}/data", { payload: different_date_json }
    assert_equal 2, PayloadRequest.all.count
  end

  def test_post_non_client_responds_with_403_error
    client = Client.create(identifier: "jumpstartlab", root_url: "http://jumpstartlab.com")
    post "/sources/google/data", { payload: json_payload }
    assert_equal 403, last_response.status
    assert_equal "Client doesn't exist.", last_response.body
  end

end
