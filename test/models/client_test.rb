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

end
