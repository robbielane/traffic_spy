require './test/test_helper'

class ProcessingPayloadRequestTest < Minitest::Test
    def data
      { payload: { "url":"http://jumpstartlab.com/blog",
                  "requestedAt":"2013-02-16 21:38:28 -0700",
                  "respondedIn":37,
                  "referredBy":"http://jumpstartlab.com",
                  "requestType":"GET",
                  "parameters":[],
                  "eventName": "socialLogin",
                  "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
                  "resolutionWidth":"1920",
                  "resolutionHeight":"1280",
                  "ip":"63.29.38.211"
                  }.to_json }
    end

    def test_returns_200_when_correct_data_sent
      Source.create( {identifier: "jumpstartlab", root_url: "jumpstartlab.com"})
      post '/sources/jumpstartlab/data', data

      assert_equal 200, last_response.status
    end

    def test_returns_400_when_data_missing
      Source.create( {identifier: "jumpstartlab", root_url: "jumpstartlab.com"})
      post '/sources/jumpstartlab/data'

      assert_equal 400, last_response.status
      assert_equal "Payload not received", last_response.body
    end

    def test_returns_403_if_data_has_already_been_sent
      Source.create( {identifier: "jumpstartlab", root_url: "jumpstartlab.com"})
      post '/sources/jumpstartlab/data', data
      post '/sources/jumpstartlab/data', data

      assert_equal 403, last_response.status
      assert_equal "Payload already received", last_response.body
    end

    def test_returns_403_when_application_not_registered_and_sends_request
      post '/sources/jumpstartlab/data', data

      assert_equal 403, last_response.status
      assert_equal "Application Not Registered", last_response.body
    end
end
