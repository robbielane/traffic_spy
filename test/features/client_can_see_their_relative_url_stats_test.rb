# As a registered user
# When I visit /sources/IDENTIFIER/urls/RELATIVE/PATH
# I expect to see analytical data for:
# -Longest response time
# -Shortest response time
# -Average response time
# -Which HTTP verbs have been used
# -Most popular referrrers
# -Most popular user agents

require './test/test_helper'

class RelativeUrlStatsPageTest < FeatureTest
  def setup
    Source.create( identifier: "jumpstartlab", root_url: "http://jumpstartlab.com" )
  end

  def test_sees_correct_page_title
    create_payload(1)
    visit '/sources/jumpstartlab/urls/blog0'
    assert_equal '/sources/jumpstartlab/urls/blog0', current_path
    assert page.has_content?('Jumpstartlab Statistics for blog0')
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

  def test_error_message_is_displayed_when_relative_path_does_not_exist
    visit '/sources/jumpstartlab/urls/something'
    within('#error-message') do
      assert page.has_content?("The relative path 'something' does not exist")
    end
  end
end
