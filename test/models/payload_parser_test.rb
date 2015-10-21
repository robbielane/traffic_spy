require_relative '../test_helper'

class PayloadParserTest < Minitest::Test
  def data
    { "url":"http://jumpstartlab.com/blog",
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
    }.to_json
  end

  def test_returns_200_if_correct_payload_given
    Source.create(identifier: "jumpstartlab", root_url: "jumpstartlab.com")
    response = PayloadParser.call(data, "jumpstartlab")

    assert_equal [200, {}, ""], response
  end

  def test_returns_400_if_payload_is_missing
    Source.create(identifier: "jumpstartlab", root_url: "jumpstartlab.com")
    response = PayloadParser.call(nil, "jumpstartlab")

    assert_equal [400, {}, "Payload not received"], response
  end

  def test_returns_403_if_payload_already_recieved
    Source.create(identifier: "jumpstartlab", root_url: "jumpstartlab.com")
    response = PayloadParser.call(data, "jumpstartlab")
    response = PayloadParser.call(data, "jumpstartlab")

    assert_equal [403, {}, "Payload already received"], response
  end

  def test_returns_403_if_source_does_not_exists
    response = PayloadParser.call(data, "jumpstartlab")

    assert_equal [403, {}, "Application Not Registered"], response
  end
end
