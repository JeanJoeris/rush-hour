require_relative '../test_helper'
class JsonTablePopulatorTest < Minitest::Test
  include TestHelpers

  def payload
    '{
      "url":"http://jumpstartlab.com/blog",
      "requestedAt":"2013-02-16 21:38:28 -0700",
      "respondedIn":37,
      "referredBy":"http://jumpstartlab.com",
      "requestType":"GET",
      "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
      "resolutionWidth":"1920",
      "resolutionHeight":"1280",
      "ip":"63.29.38.211"
    }'
  end

  def parsed_payload
    JSON.parse(payload)
  end

  def test_parse_payload_request
    assert_equal 9, parsed_payload.keys.count
    assert_equal "http://jumpstartlab.com/blog", parsed_payload["url"]
  end

  def test_json_add_makes_url_from_json
    JsonTablePopulator.add(payload, 1)

    assert_equal "http://jumpstartlab.com/blog", Url.all.first.url_path
  end

  def test_json_add_makes_referrer_from_json
    JsonTablePopulator.add(payload, 1)

    assert_equal "http://jumpstartlab.com", Referrer.all.first.name
  end

  def test_json_add_makes_request_type_from_json
    JsonTablePopulator.add(payload, 1)

    assert_equal "GET", RequestType.all.first.http_verb
  end

  def test_json_add_makes_agent_from_json
    JsonTablePopulator.add(payload, 1)

    assert_equal "OS X 10.8.2", Agent.all.first.os
    assert_equal "Chrome", Agent.all.first.browser
  end

  def test_json_add_makes_screen_resolution_from_json
    JsonTablePopulator.add(payload, 1)

    assert_equal "1920", ScreenResolution.all.first.width
    assert_equal "1280", ScreenResolution.all.first.height
  end

  def test_json_add_makes_ip_from_json
    JsonTablePopulator.add(payload, 1)

    assert_equal "63.29.38.211", Ip.all.first.address
  end

  def test_json_add_will_create_the_payload
    JsonTablePopulator.add(payload, 1)
    assert_equal 1, PayloadRequest.all.count
  end
end
