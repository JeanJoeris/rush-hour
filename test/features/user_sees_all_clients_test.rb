require_relative "../test_helper"

class UserSeesAllClients < FeatureTest
  include TestHelpers

  def test_user_sees_all_clients_on_the_sources_page
    Client.create(identifier: "client one", root_url: "www.clientone.com")
    Client.create(identifier: "client two", root_url: "www.clienttwo.com")
    visit '/sources'
    assert page.has_content?("Client one")
    assert page.has_content?("Client two")
  end
end
