require './test/test_helper'

class EventStatsPageTest < FeatureTest
  def setup
    Source.create( identifier: "jumpstartlab", root_url: "http://jumpstartlab.com" )
  end

  def test_client_sees_page_title
    create_payload(1)
    visit '/sources/jumpstartlab/events'
    assert_equal '/sources/jumpstartlab/events', current_path
    within('h1') do
      assert has_content?('Jumpstartlab Event Statistics')
    end
  end

  def test_client_sees_list_off_all_events_in_ascending_order
    create_payload(3)
    create_similar_payload(1)
    visit '/sources/jumpstartlab/events'

    within('#events') do
      assert has_content?('socialLogin0 2')
      assert has_content?('socialLogin1 1')
      assert has_content?('socialLogin2 1')
    end
  end

  def test_list_of_events_are_links_to_correct_pages
    create_payload(3)
    visit '/sources/jumpstartlab/events'
    click_link('socialLogin0')

    assert_equal '/sources/jumpstartlab/events/socialLogin0', current_path

    visit '/sources/jumpstartlab/events'
    click_link('socialLogin2')

    assert_equal '/sources/jumpstartlab/events/socialLogin2', current_path
  end

  def test_client_sees_message_that_no_events_defined_if_no_events_exist
    visit '/sources/jumpstartlab/events'

    assert page.has_content?( 'No events have been defined')
  end
end
