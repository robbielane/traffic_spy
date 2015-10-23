require './test/test_helper'

class EventStatisticsTest < Minitest::Test
  def test_event_hourly_breakdown_returns_correct_data
    create_source
    create_same_event_name_payload(3)

    result = EventStatistics.new('jumpstartlab').event_hourly_breakdown('socialLogin')

    assert_equal({ "12 am - 1 am" => 1, "1 am - 2 am" => 1, "2 am - 3 am" => 1}, result)
  end
end
