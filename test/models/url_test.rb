require_relative '../test_helper'

class UrlTest < Minitest::Test
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

    payload = PayloadRequest.create(get_payload_data)

    assert_equal payload, url.payload_requests.first
  end

  def test_url_can_find_max_response_time_of_all_payloads
    payload_data_1 = get_payload_data

    payload_data_2 = get_payload_data
    payload_data_2["responded_in"] = 20

    payload_data_3 = get_payload_data
    payload_data_3["responded_in"] = 200

    create_payload(
                  [ payload_data_1,
                    payload_data_2,
                    payload_data_3 ]
                  )

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

  def test_that_min_response_time_of_payload_requests_is_calculated
    payload_data_1 = get_payload_data
    payload_data_1["responded_in"] = 10
    payload_data_1["url_id"] = 2
    payload_data_2 = get_payload_data
    payload_data_2["responded_in"] = 20
    payload_data_2["url_id"] = 2
    payload_data_3 = get_payload_data
    payload_data_3["responded_in"] = 30
    payload_data_3["url_id"] = 2

    create_payload(
                  [ payload_data_1,
                    payload_data_2,
                    payload_data_3 ]
                  )

    url_data_1 = create_params
    url_data_2 = create_params

    assert_equal 10, url_data_2.min_response_time
  end


  def test_url_finds_all_verbs_associated_with_it
    populate_request_types_table

    payload_data_1 = get_payload_data
    payload_data_2 = get_payload_data
    payload_data_2["request_type_id"] = 2
    payload_data_3 = get_payload_data
    payload_data_3["request_type_id"] = 3

    create_payload(
                  [ payload_data_1,
                    payload_data_2,
                    payload_data_2,
                    payload_data_3,
                    payload_data_3,
                    payload_data_3]
                  )

    google = create_params

    assert_equal ["PUT: 3", "POST: 2", "GET: 1"], google.http_verbs_report
  end

  def test_url_only_find_verbs_associated_with_it
    populate_request_types_table

    payload_data_1 = get_payload_data

    payload_data_2 = get_payload_data
    payload_data_2["request_type_id"] = 2

    payload_data_3 = get_payload_data
    payload_data_3["request_type_id"] = 3
    payload_data_3["url_id"] = 2

    create_payload(
                  [ payload_data_1,
                    payload_data_2,
                    payload_data_2,
                    payload_data_3 ]
                  )

    google = create_params
    reddit = Url.create(url_path: "http://reddit.com")

    assert_equal ["POST: 2", "GET: 1"], google.http_verbs_report
  end

  def test_a_list_of_response_time_across_all_requests_listed_from_longest_to_shortest
    payload_data_1 = get_payload_data
    payload_data_1["responded_in"] = 10
    payload_data_2 = get_payload_data
    payload_data_2["responded_in"] = 20
    payload_data_3 = get_payload_data
    payload_data_3["responded_in"] = 30

    create_payload(
                  [ payload_data_1,
                    payload_data_2,
                    payload_data_3 ]
                  )

    # PayloadRequest.create(payload_data_1)
    # PayloadRequest.create(payload_data_2)
    # PayloadRequest.create(payload_data_3)

    url_data_1 = create_params

    assert_equal [30, 20, 10], url_data_1.response_times
  end

  def test_most_popular_finds_the_three_most_popular_referrers
    payload_data_1 = get_payload_data
    payload_data_1["referrer_id"] = 1
    payload_data_2 = get_payload_data
    payload_data_2["referrer_id"] = 2
    payload_data_3 = get_payload_data
    payload_data_3["referrer_id"] = 3
    payload_data_4 = get_payload_data
    payload_data_4["referrer_id"] = 4

    create_payload(
                  [ payload_data_1,
                    payload_data_1,
                    payload_data_2,
                    payload_data_3,
                    payload_data_3,
                    payload_data_3,
                    payload_data_3,
                    payload_data_4,
                    payload_data_4,
                    payload_data_4]
                  )

    url_data_1 = create_params

    populate_referrer_table

    assert_equal ["http://.yahoo.com", "http://.aol.com", "http://.google.com"], url_data_1.top_referrers_report

  end

  def test_average_response_time_test_the_average_response_time_for_this_url
    payload_data_1 = get_payload_data
    payload_data_1["responded_in"] = 10
    payload_data_2 = get_payload_data
    payload_data_2["responded_in"] = 20
    payload_data_3 = get_payload_data
    payload_data_3["responded_in"] = 30

    create_payload(
                  [ payload_data_1,
                    payload_data_2,
                    payload_data_3 ]
                  )

    url_data_1 = create_params

    assert_equal 20, url_data_1.average_response_time
  end

  def test_url_finds_top_user_agents
    payload_data_1 = get_payload_data

    payload_data_2 = get_payload_data
    payload_data_2["agent_id"] = 2

    payload_data_3 = get_payload_data
    payload_data_3["agent_id"] = 3
    create_payload(
                    [
                      payload_data_1,
                      payload_data_1,
                      payload_data_1,
                      payload_data_2,
                      payload_data_3,
                      payload_data_3
                    ]
                  )

    test_url = create_params
    agent_1 = Agent.create(os: "Intel Mac OS X 10_8_2", browser: "Chrome")
    agent_2 = Agent.create(os: "Microsoft Windows 10", browser: "IEewwwww")
    agent_3 = Agent.create(os: "Debian Redhat version x.x", browser: "Chromium")

    agents = test_url.top_agents_report
    assert_equal agent_1.os, agents.first
    assert_equal agent_3.os, agents[1]
    assert_equal agent_2.os, agents.last
  end

end
