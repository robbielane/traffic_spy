class IdentifierStatisticsTest < Minitest::Test
  def test_browser_breakdown_returns_correct_data
    create_source
    create_payload(2)

    result = IdentifierStatistics.new('jumpstartlab').browser_breakdown

    assert_equal [{"Chrome" => 2}], result
  end

  def test_browser_breakdown_returns_correct_data
    create_source
    create_payload(2)

    result = IdentifierStatistics.new('jumpstartlab').os_breakdown

    assert_equal [{"Macintosh" => 1}, {"Windows"=>1}], result
  end

  def test_screen_resolutions_returns_correct_data
    create_source
    create_payload(3)
    create_similar_payload(2)

    result = IdentifierStatistics.new('jumpstartlab').screen_resolutions

    assert_equal({ "1920 x 1280" => 3, "800 x 600" => 2}, result)
  end

  def test_url_response_times_returns_correct_data
    create_source
    create_payload(3)
    create_similar_payload(2)

    result = IdentifierStatistics.new("jumpstartlab").url_response_times

    assert_equal({ "http://jumpstartlab.com/blog0" => 6,
                   "http://jumpstartlab.com/blog1" => 7,
                   "http://jumpstartlab.com/blog2" => 5}, result)
  end
end
