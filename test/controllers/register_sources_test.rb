require './test/test_helper'

class RegisterSourceTest < Minitest::Test

  def test_client_cant_register_with_missing_parameters
    total_sources = Source.count

    post '/sources', { identifier: "turing" }

    assert_equal 0, total_sources - Source.count
    assert_equal 400, last_response.status
    assert_equal "RootUrl can't be blank", last_response.body
#   As an unregistered User
# When I send a post request to http://locahost:9393/sources
# With any of the required parameters missing
# I expect to return status 400 Bad Request with a descriptive error message.
  end

  def test_client_can_register
    skip
  end

end
