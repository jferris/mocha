require File.join(File.dirname(__FILE__), "..", "test_helper")
require 'mocha/mock'
require 'mocha/expectation_error'

class MockTest < Test::Unit::TestCase
  
  include Mocha
  
  def test_should_include_mocha_methods
   assert Mock.included_modules.include?(MockMethods)
  end

  def test_should_set_single_expectation
   mock = Mock.new
   mock.expects(:method1).returns(1)
   assert_nothing_raised(ExpectationError) do
     assert_equal 1, mock.method1
   end
  end 

  def test_should_build_and_store_expectations
   mock = Mock.new
   expectation = mock.expects(:method1)
   assert_not_nil expectation
   assert_equal [expectation], mock.expectations
  end
  
  def test_should_not_stub_everything_by_default
    mock = Mock.new
    assert_equal false, mock.stub_everything
  end
  
  def test_should_stub_everything
    mock = Mock.new(stub_everything = true)
    assert_equal true, mock.stub_everything
  end
  
  def test_should_display_object_id_for_inspect_if_mock_has_no_name
    mock = Mock.new
    assert_match Regexp.new("#<Mock:0x[0-9A-Fa-f]{6}>"), mock.mocha_inspect
  end
  
  def test_should_display_name_for_inspect_if_mock_has_name
    mock = Mock.new(false, 'named_mock')
    assert_equal "#<Mock:named_mock>", mock.mocha_inspect
  end

  def test_should_give_name_in_inspect_message
    mock = Mock.new(false, 'named_mock')
    assert_equal "#<Mock:named_mock>", mock.mocha_inspect
  end
  
  def test_should_be_able_to_extend_mock_object_with_module
    mock = Mock.new
    assert_nothing_raised(ExpectationError) { mock.extend(Module.new) }
  end
  
  def test_should_be_equal_to_avoid_strange_breakage_of_published_review_list_test_in_revieworld
    mock = Mock.new
    assert_equal true, mock.eql?(mock)
  end
    
end