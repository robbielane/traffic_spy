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
    save_and_open_page
    within('#hour-by-hour') do
      assert has_content?('1')
      assert has_content?('12 am - 1 am')
      assert has_content?('1 am - 2 am')
      assert has_content?('2 am - 3 am')
    end
  end
end
