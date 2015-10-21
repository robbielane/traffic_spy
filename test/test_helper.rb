ENV["RACK_ENV"] ||= "test"

require 'bundler'
Bundler.require(:test)

require File.expand_path("../../config/environment", __FILE__)
require 'minitest/autorun'
require 'tilt/erb'

Capybara.app = TrafficSpy::Server

DatabaseCleaner.strategy = :truncation, {except: %w[public.schema_migrations]}

class Minitest::Test
  include Rack::Test::Methods

  def app
    TrafficSpy::Server
  end

  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end

  def create_source
    Source.create(identifier: "jumpstartlab", root_url: "http://jumpstartlab.com")
  end

  def create_payload(num)
    jumpstartlab = Source.find_by_identifier("jumpstartlab")
    num.times do |i|
      jumpstartlab.payloads.create({ url: "http://jumpstartlab.com/blog#{i}",
        requested_at: "2013-02-1#{i} 21:38:28 -0700",
        responded_in: 3 + i,
        referred_by:"http://jumpstartlab.com",
        request_type: "GET",
        event_name: "socialLogin",
        user_agent: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
        resolution_width: "1920",
        resolution_height: "1280",
        ip: "63.29.38.21#{i}"
      } )
    end
  end

  def create_similar_payload(num)
    jumpstartlab = Source.find_by_identifier("jumpstartlab")
    num.times do |i|
      jumpstartlab.payloads.create({ url: "http://jumpstartlab.com/blog#{i}",
        requested_at: "2013-03-1#{i} 21:38:28 -0700",
        responded_in: 3 + i,
        referred_by:"http://jumpstartlab.com",
        request_type: "GET",
        event_name: "socialLogin",
        user_agent: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
        resolution_width: "1920",
        resolution_height: "1280",
        ip: "63.29.38.21#{i}"
      } )
    end
  end
end

class FeatureTest < Minitest::Test
  include Capybara::DSL
end
