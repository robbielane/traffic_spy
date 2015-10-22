require './test/test_helper'

class EventStatisticsTest < Minitest::Test
  def test_events_returns_sorted_list_of_events
    create_source
    create_payload(3)
    create_similar_payload(1)

    result = EventStatistics.new("jumpstartlab").events

    assert_equal({"socialLogin0" => 2, "socialLogin1" => 1, "socialLogin2" => 1}, result)
  end

  def test_event_hourly_breakdown_returns_correct_data
    create_source
    create_same_event_name_payload(3)

    result = EventStatistics.new('jumpstartlab').event_hourly_breakdown('socialLogin')

    assert_equal({ "12 am - 1 am" => 1, "1 am - 2 am" => 1, "2 am - 3 am" => 1}, result)
  end
end
