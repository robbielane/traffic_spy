require './test/test_helper'

class ProcessingPayloadRequestTest < Minitest::Test
  def create_data
    create_source
    create_payload(1)
  end

  def test_identifier_api_returns_correct_data
    create_data
    get '/sources/jumpstartlab.json'
    expected = {"top_urls"=>{"http://jumpstartlab.com/blog0"=>1},
                 "browser_breakdown"=>{"Chrome"=>1},
                 "os_breakdown"=>{"Windows"=>1},
                 "screen_resolutions"=>{"[\"1920\", \"1280\"]"=>1},
                 "average_response_times"=>{"http://jumpstartlab.com/blog0"=>3.0}}

    assert_equal expected, JSON.parse(last_response.body)
  end

  def test_relative_path_api_returns_correct_data
    create_data
    get '/sources/jumpstartlab/urls.json'
    expected = {"http://jumpstartlab.com/blog0"=>
                  {"response_times"=>{"longest"=>3.0,"shortest"=>3.0,"average"=>"3.0"},
                   "user_agent_breakdown"=>{"Chrome"=>1},
                   "referrers"=>{"http://jumpstartlab0.com"=>1},
                   "request_types"=>["GET0"]}}

    assert_equal expected, JSON.parse(last_response.body)
  end

  def test_event_api_returns_correct_data
    create_data
    get '/sources/jumpstartlab/events.json'
    expected = {"socialLogin0"=>{"9 pm - 10 pm"=>1}}

    assert_equal expected, JSON.parse(last_response.body)
  end
end
