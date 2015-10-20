require './test/test_helper'

class RegisterSourceTest < Minitest::Test

  def test_client_cant_register_with_missing_root_url
    total_sources = Source.count

    post '/sources', { source: { identifier: "turing" } }

    assert_equal 0, total_sources - Source.count
    assert_equal 400, last_response.status
    assert_equal "Root url can't be blank", last_response.body
  end

  def test_client_cant_register_with_missing_identifier
    total_sources = Source.count

    post '/sources', { source: { root_url: "http://turing.io" } }

    assert_equal 0, total_sources - Source.count
    assert_equal 400, last_response.status
    assert_equal "Identifier can't be blank", last_response.body
  end

  def test_client_can_register
    total_sources = Source.count

    post '/sources', { source: { identifier: "turing", root_url: "http://turing.io" } }

    assert_equal 1, Source.count - total_sources
    assert_equal 200, last_response.status
    assert_equal "Success", last_response.body
    assert last_response.headers.has_key?("identifier")
    assert last_response.headers.has_value?("turing")
  end

#     As an unregistered User
# When I send A post request to http://locahost:9393/sources
# With the data - Identifier and rootUrl ('identifier=jumpstartlab&rootUrl=http://jumpstartlab.com')
# I expect to see a response of "identifier: jumpstartlab" and the status of 200


end
