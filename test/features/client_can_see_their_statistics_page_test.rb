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

  def test_sees_correct_page_title
    visit '/sources/jumpstartlab'
    assert_equal '/sources/jumpstartlab', current_path
    assert page.has_content?('Jumpstartlab Statistics')
  end

  def test_can_see_most_to_least_requested_urls
    create_payload(10)
    create_similar_payload(1)
    visit '/sources/jumpstartlab'
    assert page.has_content?('Most Requested URLs')

    within('#top-urls') do
      assert has_content?('2')
      assert has_content?('http://jumpstartlab.com/blog0')
    end
  end

  
end
