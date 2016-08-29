require_relative "../test_helper"

class UserCanClickTheHomeAndClientsLinksFromAnyPage < FeatureTest
  include TestHelpers

  def setup_tables_for_minimum_data_represented
    @client = Client.create(identifier: "reddit", root_url: 'http://www.reddit.com')
    populate_referrer_table
    populate_agent_table
    populate_url_paths_on_client #1=> /sports, 2 => /blog, 3 => /news
    payload_1 = get_payload_data
    payload_2 = get_payload_data
    payload_2[:url_id] = 2
    payload_3 = get_payload_data
    payload_3[:url_id] = 3
    create_payload([payload_1, payload_2, payload_3])
  end

  def test_user_can_click_the_home_link_from_any_page
    setup_tables_for_minimum_data_represented
    visit '/'
    click_link 'Home'

    assert has_content? 'Rush-Hour is a website traffic tracking service.'

    visit '/sources'
    click_link 'Home'

    assert has_content? 'Rush-Hour is a website traffic tracking service.'

    visit "/sources/#{@client.identifier}"
    click_link 'Home'

    assert has_content? 'Rush-Hour is a website traffic tracking service.'

    visit "/sources/#{@client.identifier}/urls/sports"
    click_link 'Home'

    assert has_content? 'Rush-Hour is a website traffic tracking service.'

    visit "/sources/#{@client.identifier}/urls/blog"
    click_link 'Home'

    assert has_content? 'Rush-Hour is a website traffic tracking service.'

    visit "/sources/#{@client.identifier}/urls/news"
    click_link 'Home'

    assert has_content? 'Rush-Hour is a website traffic tracking service.'
  end

  def test_user_can_click_clients_link_from_every_page
    setup_tables_for_minimum_data_represented
    visit '/'
    click_link 'Clients'

    assert has_content? "#{@client.identifier.capitalize}"
    assert has_content? "Clients"

    visit '/sources'
    click_link 'Clients'

    assert has_content? "#{@client.identifier.capitalize}"
    assert has_content? "Clients"

    visit "/sources/#{@client.identifier}"
    click_link 'Clients'

    assert has_content? "#{@client.identifier.capitalize}"
    assert has_content? "Clients"

    visit "/sources/#{@client.identifier}/urls/sports"
    click_link 'Clients'

    assert has_content? "#{@client.identifier.capitalize}"
    assert has_content? "Clients"

    visit "/sources/#{@client.identifier}/urls/blog"
    click_link 'Clients'

    assert has_content? "#{@client.identifier.capitalize}"
    assert has_content? "Clients"

    visit "/sources/#{@client.identifier}/urls/news"
    click_link 'Clients'

    assert has_content? "#{@client.identifier.capitalize}"
    assert has_content? "Clients"
  end
end
