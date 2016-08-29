require_relative "../test_helper"

class UserCanClickBackToClientsFromUrlPathsPageTest < FeatureTest
  include TestHelpers

  def test_user_can_click_back_to_clients_from_url_paths_page
    populate_url_paths_on_client  #1=> /sports, 2 => /blog, 3 => /news
    create_payload(get_payload_data)
    populate_referrer_table
    populate_agent_table
    client = Client.create(identifier: "reddit", root_url: "http://www.reddit.com")

    visit "/sources/#{client.identifier}/urls/sports"
    assert has_content? 'Path:'
    click_link "#{client.identifier.capitalize}"
    refute has_content? 'Path'
    assert has_content? 'Reddit'

    visit "/sources/#{client.identifier}/urls/sports"
    assert has_content? 'Path:'
    click_link "Back to #{client.identifier.capitalize}"
    refute has_content? 'Path'
    assert has_content? 'Reddit'
  end
end
