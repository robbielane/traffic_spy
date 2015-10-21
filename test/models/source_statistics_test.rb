require './test/test_helper'

class StatisticsTest < Minitest::Test
  def test_top_urls_returns_top_urls
    create_source
    create_payload(2)
    create_similar_payload(1)

    result = SourceStatistics.top_urls("jumpstartlab")

    assert_equal [{"http://jumpstartlab.com/blog0" => 2}, {"http://jumpstartlab.com/blog1" => 1}], result
  end

  def test_browser_breakdown_returns_correct_data
    create_source
    create_payload(2)

    result = SourceStatistics.browser_breakdown('jumpstartlab')

    assert_equal [{"Chrome" => 2}], result
  end
end
