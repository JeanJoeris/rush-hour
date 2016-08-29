require_relative "../test_helper"

class UserCanClickOnEachClientToViewTheClientPage < FeatureTest
  include TestHelpers

  def test_user_can_click_on_each_client_to_view_the_client_page
    Client.create(identifier: "clientone", root_url: "www.clientone.com")
    Client.create(identifier: "clienttwo", root_url: "www.clienttwo.com")
    payload_1 = get_payload_data
    create_payload(payload_1)
    visit '/sources'
    assert has_link?('Clientone')
    refute has_link?('Clienttwo')
  end

  def test_user_can_view_data_when_clicking_the_client_name
    Client.create(identifier: "clientone", root_url: "www.clientone.com")
    Client.create(identifier: "clienttwo", root_url: "www.clienttwo.com")
    payload_1 = get_payload_data
    create_payload(payload_1)
    visit '/sources'
    click_link('Clientone')
    assert has_content? "Average Response Time:"
  end
end
