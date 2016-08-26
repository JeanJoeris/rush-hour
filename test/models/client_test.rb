require_relative '../test_helper'

class ClientTable < Minitest::Test
  include TestHelpers

  def get_client
    Client.create(identifier: "Some string", root_url: "http://www.google.com")
  end

  def test_it_assigns_attributes_correctly
    client = get_client
    assert_equal Client, client.class
    assert_equal "Some string", client.identifier
    assert_equal "http://www.google.com", client.root_url
  end

  def test_only_valid_entries_are_entered
    Client.create({})
    assert_equal 0, Client.all.count

    get_client
    assert_equal 1, Client.all.count
  end

  def test_clients_access_payload_requests
    create_payload([get_payload_data, get_payload_data, get_payload_data, get_payload_data])

    client = get_client

    assert_equal PayloadRequest, client.payload_requests.first.class
    assert_equal 4, client.payload_requests.count
  end

  def test_urls_can_be_accessed_through_client_class
    payload_data_1 = get_payload_data
    payload_data_1["url_id"] = 1
    payload_data_2 = get_payload_data
    payload_data_2["url_id"] = 2
    payload_data_3 = get_payload_data
    payload_data_3["url_id"] = 3

    create_payload([payload_data_1, payload_data_2, payload_data_3])

    client = get_client
    populate_url_table

    assert_equal Url, client.urls.first.class
    assert_equal 3, client.urls.count
  end

  def test_ips_can_be_accessed_through_client_class
    payload_data_1 = get_payload_data
    payload_data_1["ip_id"] = 1
    payload_data_2 = get_payload_data
    payload_data_2["ip_id"] = 2
    payload_data_3 = get_payload_data
    payload_data_3["ip_id"] = 3

    create_payload([payload_data_1, payload_data_2, payload_data_3])

    client = get_client
    populate_ip_table

    assert_equal Ip, client.ips.first.class
    assert_equal 3, client.ips.count
  end

  def test_agents_can_be_accessed_through_client_class
    payload_data_1 = get_payload_data
    payload_data_1["agent_id"] = 1
    payload_data_2 = get_payload_data
    payload_data_2["agent_id"] = 2
    payload_data_3 = get_payload_data
    payload_data_3["agent_id"] = 3

    create_payload([payload_data_1, payload_data_2, payload_data_3])

    client = get_client
    populate_agent_table

    assert_equal Agent, client.agents.first.class
    assert_equal 3, client.agents.count
  end

  def test_referrer_can_be_accessed_through_client_class
    payload_data_1 = get_payload_data
    payload_data_1["referrer_id"] = 1
    payload_data_2 = get_payload_data
    payload_data_2["referrer_id"] = 2
    payload_data_3 = get_payload_data
    payload_data_3["referrer_id"] = 3

    create_payload([payload_data_1, payload_data_2, payload_data_3])

    client = get_client
    populate_referrer_table

    assert_equal Referrer, client.referrers.first.class
    assert_equal 3, client.referrers.count
  end

  def test_screen_resolution_can_be_accessed_through_client_class
    payload_data_1 = get_payload_data
    payload_data_1["screen_resolution_id"] = 1
    payload_data_2 = get_payload_data
    payload_data_2["screen_resolution_id"] = 2
    payload_data_3 = get_payload_data
    payload_data_3["screen_resolution_id"] = 3

    create_payload([payload_data_1, payload_data_2, payload_data_3])

    client = get_client
    populate_screen_resoultion_table

    assert_equal ScreenResolution, client.screen_resolutions.first.class
    assert_equal 3, client.screen_resolutions.count
  end

  def test_request_type_can_be_accessed_through_client_class
    payload_data_1 = get_payload_data
    payload_data_1["request_type_id"] = 1
    payload_data_2 = get_payload_data
    payload_data_2["request_type_id"] = 2
    payload_data_3 = get_payload_data
    payload_data_3["request_type_id"] = 3

    create_payload([payload_data_1, payload_data_2, payload_data_3])

    client = get_client
    populate_request_types_table

    assert_equal RequestType, client.request_types.first.class
    assert_equal 3, client.request_types.count
  end

end
