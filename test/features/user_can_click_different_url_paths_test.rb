require_relative "../test_helper"

class UserCanClickDifferentUrlPaths < FeatureTest
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

  def test_user_can_click_on_sports_link
    setup_tables_for_minimum_data_represented
    visit "/sources/#{@client.identifier}"
    click_link("/sports")
    assert has_content?("Path: #{@client.urls.first.url_path}")
  end

  def test_user_can_click_on_blog_link
    setup_tables_for_minimum_data_represented

    visit "/sources/#{@client.identifier}"
    click_link("/blog")
    assert has_content?("Path: #{@client.urls[1].url_path}")
  end

  def test_user_can_click_on_news_link
    setup_tables_for_minimum_data_represented

    visit "/sources/#{@client.identifier}"
    click_link("/news")
    assert has_content?("Path: #{@client.urls.last.url_path}")
  end
  
end
