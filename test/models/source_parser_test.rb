require_relative '../test_helper'

class SourceParserTest < Minitest::Test
  def test_returns_200_if_correct_params_given
    response = SourceParser.call( { identifier: "turing", rootUrl: "http://turing.io"})

    assert_equal [200, {"identifier" => "turing"}, "Success"], response
  end

  def test_returns_400_if_rooturl_param_is_missing
    response = SourceParser.call( { identifier: "turing"} )

    assert_equal [400, {}, "Root url can't be blank"], response
  end

  def test_returns_400_if_identifier_param_is_missing
    response = SourceParser.call( { rootUrl: "http://turing.io"} )

    assert_equal [400, {}, "Identifier can't be blank"], response
  end

  def test_returns_403_if_identifier_already_exists
    response = SourceParser.call( { identifier: "turing", rootUrl: "http://turing.io"} )
    response = SourceParser.call( { identifier: "turing", rootUrl: "http://turing.io"} )

    assert_equal [403, {}, "Identifier has already been taken"], response
  end
end
