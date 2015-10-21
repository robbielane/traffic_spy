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

  def test_sees_correct_page_title
    visit '/sources/jumpstartlab'
    assert_equal '/sources/jumpstartlab', current_path
    assert page.has_content?('Jumpstartlab Statistics')
  end

  def test_error_message_is_displayed_when_source_does_not_exist
    visit '/sources/idonotexist'
    within('#error-message') do
      assert page.has_content?('idonotexist is not Registered with Traffic Spy')
    end
  end

  def test_can_see_most_to_least_requested_urls
    create_payload(10)
    create_similar_payload(1)
    visit '/sources/jumpstartlab'
    assert page.has_content?('Most Requested URLs')

    within('#top-urls') do
      assert has_content?('2')
      assert has_content?('http://jumpstartlab.com/blog0')
      assert has_content?('1')
      assert has_content?('http://jumpstartlab.com/blog1')
    end
  end

  def test_can_see_web_browser_breakdown
    create_payload(5)
    visit '/sources/jumpstartlab'
    assert page.has_content?('Browser Breakdown')

    within('#browsers') do
      assert has_content?('Chrome')
    end
  end

  def test_can_see_operating_system_breakdown
    create_payload(5)
    visit '/sources/jumpstartlab'
    assert page.has_content?('Operating System Breakdown')

    within('#os') do
      assert has_content?('Macintosh')
    end
  end

  def test_can_see_screen_resolution_data
    create_payload(3)
    create_similar_payload(2)
    visit '/sources/jumpstartlab'
    assert page.has_content?('Screen Resolution')

    within('#screen-resolution') do
      assert has_content?('1920 x 1280 3')
      assert has_content?('800 x 600 2')
    end
  end

end
