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

  def return_source
    Source.find_by_identifier("jumpstartlab")
  end

  def create_user_agents
    Agent.create(platform: "Windows", browser: "Chrome")
    Agent.create(platform: "Macintosh", browser: "Firefox")
  end

  def payload(i)
    create_user_agents
    user_agents = [1,2]

    #  user_agents = ["Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
    #                 "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:40.0) Gecko/20100101 Firefox/40.1"]

      #  url: "http://jumpstartlab.com/blog#{i}",
    {
     requested_at: "2013-02-1#{i} 21:38:28 -0700",
     responded_in: 3 + i,
     referred_by: "http://jumpstartlab#{i}.com",
     request_type: "GET#{i}",
     event_name: "socialLogin#{i}",
     agent_id: user_agents[i%2],
     resolution_width: "1920",
     resolution_height: "1280",
     ip: "63.29.38.21#{i}",
     url_id: (i+1)
    }
   end

   def create_payload(num)
     jumpstartlab = return_source
     num.times do |i|
       Url.create(path: "http://jumpstartlab.com/blog#{i}")
       jumpstartlab.payloads.create(payload(i))
     end
   end

   def create_similar_payload(num)
     jumpstartlab = return_source
     num.times do |i|
       Url.create(path: "http://jumpstartlab.com/blog#{i}")
       new_payload = payload(i)
       new_payload[:responded_in] = 5 + (i+5)
       new_payload[:resolution_width] = "800"
       new_payload[:resolution_height] = "600"
       jumpstartlab.payloads.create(new_payload)
     end
   end

   def create_same_url_payload(num)
     jumpstartlab = return_source
     Url.create(path: "http://jumpstartlab.com/blog")
     num.times do |i|
       new_payload = payload(i)
       new_payload[:url_id] = 1
       jumpstartlab.payloads.create(new_payload)
     end
   end

   def create_same_event_name_payload(num)
     return nil if num > 9
     jumpstartlab = return_source
     num.times do |i|
       Url.create(path: "http://jumpstartlab.com/blog#{i}")
       new_payload = payload(i)
       new_payload[:event_name] = "socialLogin"
       new_payload[:requested_at] = "2013-03-12 0#{i}:38:28 -0700"
       jumpstartlab.payloads.create(new_payload)
     end
   end
end

class FeatureTest < Minitest::Test
  include Capybara::DSL
end
