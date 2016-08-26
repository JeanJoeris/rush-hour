ENV["RACK_ENV"] ||= "test"

require 'bundler'
Bundler.require

require File.expand_path("../../config/environment", __FILE__)
require 'minitest/autorun'
require 'minitest/pride'
require 'capybara/dsl'
require 'pry'
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation
Capybara.app = RushHour::Server

module TestHelpers
  def setup
    DatabaseCleaner.clean
  end

  def create_payload(*args)
    args.each do |arg|
      PayloadRequest.create(arg)
    end
  end

  def get_payload_data
    {
      "requested_at" => DateTime.now,
      "responded_in" => 1,
      "ip_id" => 1,
      "url_id" => 1,
      "referrer_id" => 1,
      "agent_id" => 1,
      "screen_resolution_id" => 1,
      "request_type_id" => 1,
      "client_id" => 1
    }
  end

  def populate_request_types_table
    RequestType.create(http_verb: "GET")
    RequestType.create(http_verb: "POST")
    RequestType.create(http_verb: "PUT")
    RequestType.create(http_verb: "PATCH")
    RequestType.create(http_verb: "DELETE")
  end

  def populate_url_table
    Url.create("url_path"=>"http://www.google.com")
    Url.create("url_path"=>"http://www.reddit.com")
    Url.create("url_path"=>"http://www.yahoo.com")
  end

  def populate_agent_table
    Agent.create(os: "Intel Mac OS X 10_8_2", browser:"Chrome")
    Agent.create(os: "Intel Mac OS X 10_8_2", browser:"Firefox")
    Agent.create(os: "Microsoft Windows 10", browser: "IEewwwww")
    Agent.create(os: "Debian Redhat version x.x", browser: "Chromium")
  end

  def populate_screen_resoultion_table
    ScreenResolution.create(height: "1000", width: "2000")
    ScreenResolution.create(height: "1500", width: "2500")
    ScreenResolution.create(height: "1100", width: "2100")
    ScreenResolution.create(height: "1500", width: "2600")
  end

  def populate_referrer_table
    Referrer.create("name" => "http://.google.com")
    Referrer.create("name" => "http://.reddit.com")
    Referrer.create("name" => "http://.yahoo.com")
    Referrer.create("name" => "http://.aol.com")
  end

  def populate_ip_table
    Ip.create(address: "192.168.0.1")
    Ip.create(address: "192.168.0.2")
    Ip.create(address: "192.168.0.3")
  end

end
