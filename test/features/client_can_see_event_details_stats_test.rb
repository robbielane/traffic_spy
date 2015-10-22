require './test/test_helper'

class EventDetailsStatsTest < FeatureTest
  def setup
    Source.create( identifier: "jumpstartlab", root_url: "http://jumpstartlab.com" )
  end

  def test_sees_correct_page_title
    create_payload(1)
    visit '/sources/jumpstartlab/events/socialLogin0'

    assert_equal '/sources/jumpstartlab/events/socialLogin0', current_path

    within('h1') do
      assert has_content?('socialLogin0 Statistics')
    end
  end

  def test_client_sees_hour_by_hour_breakdown_of_event
    create_same_event_name_payload(3)

    visit '/sources/jumpstartlab/events/socialLogin'

    within('h2') do
      assert has_content?('Hour By Hour Breakdown')
    end

    within('#hour-by-hour') do
      assert has_content?('1')
      assert has_content?('12 am - 1 am')
      assert has_content?('1 am - 2 am')
      assert has_content?('2 am - 3 am')
    end
  end

  def test_client_see_total_times_received
    create_same_event_name_payload(4)
    visit '/sources/jumpstartlab/events/socialLogin'

    within('#total-received') do
      assert has_content?('Total Times Received: 4')
    end
  end

  def test_if_event_has_not_been_defined_client_sees_message
    visit '/sources/jumpstartlab/events/socialLogin'

    within('#error-message') do
      assert has_content?("The event 'socialLogin' has not been defined")
    end
  end

  def test_if_event_has_not_been_defined_page_has_link_to_application_events_index
    visit '/sources/jumpstartlab/events/socialLogin'

    click_link('See Defined Events')
    assert_equal '/sources/jumpstartlab/events', current_path
  end
end
