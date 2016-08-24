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

  def get_payload_data
    {
      "requested_at" => DateTime.now,
      "responded_in" => 1,
      "ip_id" => 1,
      "url_id" => 1,
      "referrer_id" => 1,
      "agent_id" => 1,
      "screen_resolution_id" => 1,
      "request_type_id" => 1
    }
  end

  def populate_request_types_table
    RequestType.create(http_verb: "GET")
    RequestType.create(http_verb: "POST")
    RequestType.create(http_verb: "PUT")
    RequestType.create(http_verb: "PATCH")
    RequestType.create(http_verb: "DELETE")
  end
end
