require_relative '../test_helper'

class UrlsTest < Minitest::Test
  include TestHelpers

  def create_params
    params = {"url_path"=>"http://www.google.com"}
    Url.create(params)
  end

  def test_params_request_object_has_attributes
    db_params = create_params

    assert_equal "http://www.google.com", db_params["url_path"]
  end

  def test_it_requires_all_fields
    Url.create({})
    assert_equal 0, Url.all.count

    Url.create({"url_path"=>"http://www.google.com"})
    assert_equal 1, Url.all.count
  end

  def test_url_table_connects_to_payload_table
    url = create_params

    payload_params =
    {
      "requested_at" => DateTime.now,
      "responded_in" => 37,
      "ip_id" => 1,
      "url_id" => 1,
      "referrer_id" => 1,
      "agent_id" => 1,
      "screen_resolution_id" => 1,
      "request_type_id" => 1
    }

    payload = PayloadRequest.create(payload_params)

    assert_equal payload, url.payload_requests.first
  end

  def test_url_can_find_max_response_time_of_all_payloads
    payload_data_1 = get_payload_data

    payload_data_2 = get_payload_data
    payload_data_2["responded_in"] = 20

    payload_data_3 = get_payload_data
    payload_data_3["responded_in"] = 200

    PayloadRequest.create(payload_data_1)
    PayloadRequest.create(payload_data_2)
    PayloadRequest.create(payload_data_3)
    url = Url.create(url_path: "http://www.google.com")

    assert_equal 200, url.max_response_time
  end

  def test_url_max_response_time_only_looks_at_correct_payloads
    payload_data_1 = get_payload_data

    payload_data_2 = get_payload_data
    payload_data_2["responded_in"] = 20

    payload_data_3 = get_payload_data
    payload_data_3["responded_in"] = 200
    payload_data_3["url_id"] = 2

    PayloadRequest.create(payload_data_1)
    PayloadRequest.create(payload_data_2)
    PayloadRequest.create(payload_data_3)
    google = Url.create(url_path: "http://www.google.com")
    reddit = Url.create(url_path: "http://www.reddit.com")

    assert_equal 20, google.max_response_time
  end

  def test_url_finds_all_verbs_associated_with_it
    populate_request_types_table

    payload_data_1 = get_payload_data
    payload_data_2 = get_payload_data
    payload_data_2["request_type_id"] = 2
    payload_data_3 = get_payload_data
    payload_data_3["request_type_id"] = 3

    PayloadRequest.create(payload_data_1)
    PayloadRequest.create(payload_data_2)
    PayloadRequest.create(payload_data_3)

    google = create_params

    assert_equal ["GET", "POST", "PUT"], google.http_verbs.sort
  end

  def test_url_only_find_verbs_associated_with_it
    populate_request_types_table

    payload_data_1 = get_payload_data

    payload_data_2 = get_payload_data
    payload_data_2["request_type_id"] = 2

    payload_data_3 = get_payload_data
    payload_data_3["request_type_id"] = 3
    payload_data_3["url_id"] = 2

    PayloadRequest.create(payload_data_1)
    PayloadRequest.create(payload_data_2)
    PayloadRequest.create(payload_data_3)

    google = create_params
    reddit = Url.create(url_path: "http://reddit.com")

    assert_equal ["GET", "POST"], google.http_verbs
  end

  def test_url_finds_top_user_agents
    populate_request_types_table

    payload_data_1 = get_payload_data

    payload_data_2 = get_payload_data
    payload_data_2["agent_id"] = 2

    payload_data_3 = get_payload_data
    payload_data_3["agent_id"] = 3
    payloads = [
      payload_data_1,
      payload_data_1,
      payload_data_1,
      payload_data_2,
      payload_data_3,
      payload_data_3
    ]
    payloads.each do |data|
      PayloadRequest.create(data)
    end
    test_url = create_params
    agent_1 = Agent.create(os: "Intel Mac OS X 10_8_2", browser: "Chrome")
    agent_2 = Agent.create(os: "Microsoft Windows 10", browser: "IEewwwww")
    agent_3 = Agent.create(os: "Debian Redhat version x.x", browser: "Chromium")

    top_agents = test_url.top_agents
    assert_equal agent_1.id, top_agents.first.id
    assert_equal agent_3.id, top_agents[1].id
    assert_equal agent_2.id, top_agents.last.id
  end

end
