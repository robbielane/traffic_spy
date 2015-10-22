require './test/test_helper'

class RelativePathStatisticsTest < Minitest::Test
  def test_response_times_returns_correct_data
    create_source
    create_same_url_payload(3)

    result = RelativePathStatistics.new("jumpstartlab").response_times

    assert_equal({ :longest => 5, :shortest => 3, :average => 4 }, result)
  end

  #TODO: add tests for relative_path_stats
end
