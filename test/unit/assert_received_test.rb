require File.join(File.dirname(__FILE__), "..", "test_helper")
require 'test_runner'
require 'mocha/api'
require 'mocha/mockery'

class AssertReceivedTest < Test::Unit::TestCase

  include Mocha
  include TestRunner
  include Mocha::API

  def teardown
    Mockery.reset_instance
  end

  def test_passes_if_invocation_exists
    method = :a_method
    mock   = 'a mock'
    Mockery.instance.invocation(mock, method, [])
    assert_passes do
      assert_received(mock, method)
    end
  end

  def test_fails_if_invocation_doesnt_exist
    method = :a_method
    mock   = 'a mock'
    assert_fails do
      assert_received(mock, method)
    end
  end

  def test_fails_if_invocation_exists_with_different_arguments
    method = :a_method
    mock   = 'a mock'
    Mockery.instance.invocation(mock, method, [2, 1])
    assert_fails do
      assert_received(mock, method) {|expect| expect.with(1, 2) }
    end
  end

  def test_passes_if_invocation_exists_with_wildcard_arguments
    method = :a_method
    mock   = 'a mock'
    Mockery.instance.invocation(mock, method, ['hello'])
    assert_passes do
      assert_received(mock, method) {|expect| expect.with(is_a(String)) }
    end
  end

  def test_passes_if_invocation_exists_with_exact_arguments
    method = :a_method
    mock   = 'a mock'
    Mockery.instance.invocation(mock, method, ['hello'])
    assert_passes do
      assert_received(mock, method) {|expect| expect.with('hello') }
    end
  end

  def assert_passes(&block)
    assert ! fails?(&block)
  end

  def assert_fails(&block)
    assert fails?(&block)
  end

  def fails?
    begin
      yield
      false
    rescue Test::Unit::AssertionFailedError
      true
    end
  end

end
