require './test/test_helper'

class ProcessingPayloadRequestTest < Minitest::Test

  def create_data
    create_source
    create_payload(1)
  end

  def test_identifier_api_returns_correct_data
    create_data
    get '/sources/jumpstartlab.json'
    expexcted = {"top_urls"=>{"http://jumpstartlab.com/blog0"=>1},
                 "browser_breakdown"=>{"Chrome"=>1},
                 "os_breakdown"=>{"Windows"=>1},
                 "screen_resolutions"=>{"[\"1920\", \"1280\"]"=>1},
                 "average_response_times"=>{"http://jumpstartlab.com/blog0"=>3.0}}
    assert_equal expexcted, JSON.parse(last_response.body)
  end

  def test_relative_path_api
    create_data
    get '/sources/jumpstartlab/urls.json'
    expexcted = {"http://jumpstartlab.com/blog0"=>
                  {"response_times"=>{"longest"=>3.0,"shortest"=>3.0,"average"=>"3.0"},
                   "user_agent_breakdown"=>{"Chrome"=>1},
                   "referrers"=>{"http://jumpstartlab0.com"=>1},
                   "request_types"=>["GET0"]}}
    assert_equal expexcted, JSON.parse(last_response.body)
  end
end
