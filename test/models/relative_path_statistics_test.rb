require './test/test_helper'

class RelativePathStatisticsTest < Minitest::Test
  def test_response_times_returns_correct_data
    create_source
    create_same_url_payload(3)

    result = RelativePathStatistics.new("jumpstartlab", "blog").response_times
    expected = { :longest => 5, :shortest => 3, :average => 4 }

    assert_equal expected, result
  end

  def test_can_return_all_http_verbs
    create_source
    create_same_url_payload(3)

    result = RelativePathStatistics.new("jumpstartlab", "blog").http_verbs

    assert_equal %w(GET0 GET1 GET2).sort, result.sort
  end

  def test_can_return_top_user_agents
    create_source
    create_same_url_payload(3)

    result = RelativePathStatistics.new("jumpstartlab", "blog").top_user_agents
    expected = { "Chrome" => 2, "Firefox" => 1 }

    assert_equal expected, result
  end

  def test_can_return_top_referrers
    create_source
    create_same_url_payload(2)

    result = RelativePathStatistics.new("jumpstartlab", "blog").top_referrers
    expected = { "http://jumpstartlab0.com" => 1, "http://jumpstartlab1.com" => 1}

    assert_equal expected, result
  end
end
