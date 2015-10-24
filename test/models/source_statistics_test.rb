require './test/test_helper'

class SourceStatisticsTest < Minitest::Test
  # do we need all of these tests testing the same method?
  def test_can_return_top_referrers
    create_source
    create_same_url_payload(3)

    result = SourceStatistics.new("jumpstartlab").count_occurences_of(:referred_by)
    expected = {"http://jumpstartlab0.com"=>1, "http://jumpstartlab1.com"=>1, "http://jumpstartlab2.com"=>1}

    assert_equal expected, result
  end

  # =========== top_urls method is different now =============#
  # def test_top_urls_returns_top_urls
  #   create_source
  #   create_payload(2)
  #   create_similar_payload(1)
  #
  #   result = SourceStatistics.new("jumpstartlab").top_urls(:url)
  #   expected = {"http://jumpstartlab.com/blog0" => 2, "http://jumpstartlab.com/blog1" => 1}
  #
  #   assert_equal expected, result
  # end

  # we need to make sure these are sorted in the views, but can't sort a hash
  # def test_events_returns_list_of_events
  #   create_source
  #   create_payload(3)
  #   create_similar_payload(1)
  #
  #   result = SourceStatistics.new("jumpstartlab").count_occurences_of(:event_name)
  #   expected = {"socialLogin0" => 2, "socialLogin1" => 1, "socialLogin2" => 1}
  #
  #   assert_equal expected, result
  # end
end
