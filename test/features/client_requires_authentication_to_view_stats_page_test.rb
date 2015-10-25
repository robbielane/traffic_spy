require './test/test_helper'

class TrafficSpyAuthenticationTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def test_no_authentication_returns_error
    create_source
    get '/sources/jumpstartlab'

    assert_equal 401, last_response.status
  end

  def test_bad_credentials_return_error
    authorize 'wrong', 'info'
    get '/sources/jumpstartlab'

    assert_equal 401, last_response.status
  end

  def test_proper_credentials_allows_page_access
    authorize 'admin', 'admin'
    get '/sources/jumpstartlab'

    assert_equal 200, last_response.status
  end
end
