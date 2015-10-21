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
    Source.create( identifier: "jumpstartlab", root_url: "jumpstartlab.com" )
  end

  def test_sees_correct_page_title
    visit '/sources/jumpstartlab/urls/blog0'
    assert_equal '/sources/jumpstartlab/urls/blog0', current_path
    assert page.has_content?('Jumpstartlab Statistics for blog0')
  end

  def test_error_message_is_displayed_when_source_does_not_exist
    skip
    visit '/sources/'
    within('#error-message') do
      assert page.has_content?('idonotexist is not Registered with Traffic Spy')
    end
  end
end
