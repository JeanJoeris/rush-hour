require_relative '../test_helper'

class UrlsTest < Minitest::Test
  include TestHelpers

  def create_params
    params = {"url_path"=>"http://www.google.com"}
    Urls.create(params)
  end

  def test_params_request_object_has_attributes
    db_params = create_params

    assert_equal "http://www.google.com", db_params["url_path"]
  end

  def test_it_requires_all_fields
    Urls.create({})
    assert_equal 0, Urls.all.count

    Urls.create({"url_path"=>"http://www.google.com"})
    assert_equal 1, Urls.all.count
  end

end
