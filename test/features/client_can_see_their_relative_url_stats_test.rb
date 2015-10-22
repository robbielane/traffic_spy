require './test/test_helper'

class RelativeUrlStatsPageTest < FeatureTest
  def setup
    create_source
  end

  def test_sees_correct_page_title
    create_same_url_payload(1)
    visit '/sources/jumpstartlab/urls/blog'

    assert_equal '/sources/jumpstartlab/urls/blog', current_path
    assert page.has_content?('Jumpstartlab Statistics for blog')
  end

  def test_sees_data_for_response_time
    create_same_url_payload(3)
    visit '/sources/jumpstartlab/urls/blog'

    assert page.has_content?('Response Times')

    within('#response-times') do
      assert has_content?('Longest Response Time: 5')
      assert has_content?('Shortest Response Time: 3')
      assert has_content?('Average Response Time: 4')
    end
  end

  def test_sees_which_HTTP_verbs_have_been_used
    create_same_url_payload(3)
    visit '/sources/jumpstartlab/urls/blog'

    assert page.has_content?('Types of Requests Received')
    save_and_open_page
    within('#http-requests') do
      assert has_content?('GET0')
      assert has_content?('GET1')
      assert has_content?('GET2')
    end
  end

  def test_sees_most_popular_referrers
    skip
    create_same_url_payload(3)
    visit '/sources/jumpstartlab/urls/blog'

    within('#http-requests') do
      assert has_content?('1')
      assert has_content?('http://jumpstartlab0.com')
      assert has_content?('http://jumpstartlab1.com')
      assert has_content?('http://jumpstartlab2.com')
    end
  end

  def test_sees_most_popular_user_agents
    skip
    create_same_url_payload(3)
    visit '/sources/jumpstartlab/urls/blog'

    within('#user-agents') do
      assert has_content?('2')
      assert has_content?('Chrome')
      assert has_content?('1')
      assert has_content?('Firefox')
    end
  end

  def test_error_message_is_displayed_when_relative_path_does_not_exist
    visit '/sources/jumpstartlab/urls/something'

    within('#error-message') do
      assert page.has_content?("The relative path 'something' does not exist")
    end
  end
end
