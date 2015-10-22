require './test/test_helper'

class StatisticsTest < Minitest::Test
  def test_top_urls_returns_top_urls
    create_source
    create_payload(2)
    create_similar_payload(1)

    result = SourceStatistics.new("jumpstartlab").top_urls

    assert_equal [{"http://jumpstartlab.com/blog0" => 2}, {"http://jumpstartlab.com/blog1" => 1}], result
  end

  def test_browser_breakdown_returns_correct_data
    create_source
    create_payload(2)

    result = SourceStatistics.new('jumpstartlab').browser_breakdown

    assert_equal [{"Chrome" => 2}], result
  end

  def test_browser_breakdown_returns_correct_data
    create_source
    create_payload(2)

    result = SourceStatistics.new('jumpstartlab').os_breakdown

    assert_equal [{"Macintosh" => 2}], result
  end

  def test_screen_resolutions_returns_correct_data
    create_source
    create_payload(3)
    create_similar_payload(2)

    result = SourceStatistics.new('jumpstartlab').screen_resolutions

    assert_equal({ "1920 x 1280" => 3, "800 x 600" => 2}, result)
  end

  def test_url_response_times_returns_correct_data
    create_source
    create_payload(3)
    create_similar_payload(2)

    result = SourceStatistics.new("jumpstartlab").url_response_times

    assert_equal({ "http://jumpstartlab.com/blog0" => 6,
                   "http://jumpstartlab.com/blog1" => 7,
                   "http://jumpstartlab.com/blog2" => 5}, result)
  end

  def test_response_times_returns_correct_data
    create_source
    create_same_url_payload(3)

    result = SourceStatistics.new("jumpstartlab").response_times

    assert_equal({ :longest => 5, :shortest => 3, :average => 4 }, result)
  end

  def test_events_returns_sorted_list_of_events
    create_source
    create_payload(3)
    create_similar_payload(1)

    result = SourceStatistics.new("jumpstartlab").events

    assert_equal({"socialLogin0" => 2, "socialLogin1" => 1, "socialLogin2" => 1}, result)
  end

  def test_event_hourly_breakdown_returns_correct_data
    create_source
    create_same_event_name_payload(3)

    result = SourceStatistics.new('jumpstartlab').event_hourly_breakdown('socialLogin')

    assert_equal({ "12 am - 1 am" => 1, "1 am - 2 am" => 1, "2 am - 3 am" => 1}, result)
  end
end
