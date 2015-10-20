require './test/test_helper'

class RegisterSourceTest < Minitest::Test
  def test_client_cant_register_with_missing_rootUrl
    total_sources = Source.count

    post '/sources', { identifier: "turing" }

    assert_equal 0, total_sources - Source.count
    assert_equal 400, last_response.status
    assert_equal "Root url can't be blank", last_response.body
  end

  def test_client_cant_register_with_missing_identifier
    total_sources = Source.count

    post '/sources', { rootUrl: "http://turing.io" }

    assert_equal 0, total_sources - Source.count
    assert_equal 400, last_response.status
    assert_equal "Identifier can't be blank", last_response.body
  end

  def test_client_can_register
    total_sources = Source.count

    post '/sources', { identifier: "turing", rootUrl: "http://turing.io" }

    assert_equal 1, Source.count - total_sources
    assert_equal 200, last_response.status
    assert_equal "Success", last_response.body
    assert last_response.headers.has_key?("identifier")
    assert last_response.headers.has_value?("turing")
  end

  def test_client_receives_error_403_when_identifier_already_exists
    total_sources = Source.count

    post '/sources', { identifier: "turing", rootUrl: "http://turing.io" }
    post '/sources', { identifier: "turing", rootUrl: "http://turing.io" }

    assert_equal 1, Source.count - total_sources
    assert_equal 403, last_response.status
    assert_equal "Identifier has already been taken", last_response.body
  end
end
