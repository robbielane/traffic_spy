ENV["RACK_ENV"] ||= "test"

require 'bundler'
Bundler.require(:test)

require File.expand_path("../../config/environment", __FILE__)
require 'minitest/autorun'
require 'tilt/erb'
require 'test/unit'
require 'rack/test'
# require 'application'

Capybara.app = TrafficSpy::Server

DatabaseCleaner.strategy = :truncation, {except: %w[public.schema_migrations]}

module TestHelperMethods
  def create_source
    Source.create(identifier: "jumpstartlab", root_url: "http://jumpstartlab.com")
  end

  def app
    TrafficSpy::Server
  end
end

class Minitest::Test
  include Rack::Test::Methods
  include TestHelperMethods

  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end

  def return_source
    Source.find_by_identifier("jumpstartlab")
  end

  def create_user_agents
    Agent.create(platform: "Windows", browser: "Chrome")
    Agent.create(platform: "Macintosh", browser: "Firefox")
  end

  def create_request_types(i)
    RequestType.create(verb: "GET#{i}").id
  end

  def create_events(i)
    Event.create(event_name: "socialLogin#{i}").id
  end

  def create_resolutions
    Resolution.find_or_create_by(width: "1920", height: "1280")
  end

  def authorize_admin
    if page.driver.respond_to?(:basic_auth)
      page.driver.basic_auth('admin', 'admin')
    elsif page.driver.respond_to?(:basic_authorize)
      page.driver.basic_authorize('admin', 'admin')
    elsif page.driver.respond_to?(:browser) && page.driver.browser.respond_to?(:basic_authorize)
      page.driver.browser.basic_authorize('admin', 'admin')
    else
      raise "Can't login"
    end
  end

  def payload(i)
    create_user_agents
    create_resolutions
    user_agents = [1,2]
    {
     requested_at: "2013-02-1#{i} 21:38:28 -0700",
     responded_in: 3 + i,
     referred_by: "http://jumpstartlab#{i}.com",
     request_type_id: create_request_types(i),
     event_id: create_events(i),
     agent_id: user_agents[i%2],
     resolution_id: 1,
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
       Resolution.create(width: "800", height: "600")
       new_payload = payload(i)
       new_payload[:responded_in] = 5 + (i+5)
       new_payload[:resolution_id] = 2
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
       new_payload[:event_id] = Event.find_or_create_by(event_name: "socialLogin").id
       new_payload[:requested_at] = "2013-03-12 0#{i}:38:28 -0700"
       jumpstartlab.payloads.create(new_payload)
     end
   end
end

class FeatureTest < Minitest::Test
  include Capybara::DSL
end

class Test::Unit::TestCase
  include Rack::Test::Methods
  include TestHelperMethods
end
