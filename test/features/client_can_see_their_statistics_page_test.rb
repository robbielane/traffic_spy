class StatsPageTest < FeatureTest
  def setup
    Source.create( identifier: "jumpstartlab", root_url: "http://jumpstartlab.com" )
  end

  def test_sees_correct_page_title
    authorize_admin
    visit '/sources/jumpstartlab'

    assert_equal '/sources/jumpstartlab', current_path
    assert page.has_content?('Jumpstartlab Statistics')
  end

  def test_error_message_is_displayed_when_source_does_not_exist
    authorize_admin
    visit '/sources/idonotexist'

    within('#error-message') do
      assert page.has_content?('idonotexist is not Registered with Traffic Spy')
    end
  end

  def test_can_see_most_to_least_requested_urls
    create_payload(10)
    create_similar_payload(1)
    authorize_admin
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
    create_same_url_payload(5)
    authorize_admin
    visit '/sources/jumpstartlab'

    assert page.has_content?('Browser Breakdown')

    within('#browsers') do
      assert has_content?('3')
      assert has_content?('Chrome')
      assert has_content?('2')
      assert has_content?('Firefox')
    end
  end

  def test_can_see_operating_system_breakdown
    create_payload(5)
    authorize_admin
    visit '/sources/jumpstartlab'
    assert page.has_content?('Operating System Breakdown')

    within('#os') do
      assert has_content?('Macintosh')
    end
  end

  def test_can_see_screen_resolution_data
    create_payload(3)
    create_similar_payload(2)
    authorize_admin
    visit '/sources/jumpstartlab'
    assert page.has_content?('Screen Resolution')

    within('#screen-resolution') do
      assert has_content?('1920 x 1280 3')
      assert has_content?('800 x 600 2')
    end
  end

  def test_can_see_average_response_times_per_url_in_order
    create_payload(3)
    create_similar_payload(2)
    authorize_admin
    visit '/sources/jumpstartlab'
    assert page.has_content?('Average Response Time By URL')

    within('#response-times') do
      assert has_content?('http://jumpstartlab.com/blog0 6')
      assert has_content?('http://jumpstartlab.com/blog1 7')
      assert has_content?('http://jumpstartlab.com/blog2 5')
    end
  end

  def test_urls_link_to_url_specific_data
    create_payload(2)
    authorize_admin
    visit '/sources/jumpstartlab'
    within('#top-urls') do
      click_link('http://jumpstartlab.com/blog0')

      assert_equal '/sources/jumpstartlab/urls/blog0', current_path

      visit '/sources/jumpstartlab'
      click_link('http://jumpstartlab.com/blog1')
      assert_equal '/sources/jumpstartlab/urls/blog1', current_path
    end

    visit '/sources/jumpstartlab'
    within('#response-times') do
      click_link('http://jumpstartlab.com/blog0')

      assert_equal '/sources/jumpstartlab/urls/blog0', current_path

      visit '/sources/jumpstartlab'
      click_link('http://jumpstartlab.com/blog1')
      assert_equal '/sources/jumpstartlab/urls/blog1', current_path
    end
  end

  def test_link_to_events_index_works
    authorize_admin
    visit '/sources/jumpstartlab'
    click_link "Events Index"

    assert_equal '/sources/jumpstartlab/events', current_path
  end
end
