# As a registered user
# When I visit localhost/sources/IDENTIFIER
# I expect to see analytics with:
# -Most requested URLS to least requested URLS (url)
# -Web browser breakdown across all requests (userAgent)
# -OS breakdown across all requests (userAgent)
# -Screen Resolution across all requests (resolutionWidth x resolutionHeight)
# -Longest, average response time per URL to shortest, average response time per URL
# -Hyperlinks of each url to view url specific data
# -Hyperlink to view aggregate event data

class StatsPageTest < FeatureTest
  def setup
    Source.create( identifier: "jumpstartlab", root_url: "jumpstartlab.com" )
    visit '/sources/jumpstartlab'
  end

  def create_payload(num)
    num.times do |i|
      Source.payload.create(payload)
    end
  end

  def payload
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
     }
  end

  def test_sees_correct_page_title
    assert_equal '/sources/jumpstartlab', current_path
    assert page.has_content?('Jumpstartlab Statistics')
  end

  def test_can_see_most_to_least_requested_urls
    skip
    # send fake data

    within('#top-urls') do
      has_content?()
    end

  end
end
