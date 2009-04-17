require File.join(File.dirname(__FILE__), "acceptance_test_helper")
require 'mocha'
require 'matcher_helpers'

class SpyTest < Test::Unit::TestCase
  
  include AcceptanceTest
  
  def setup
    setup_acceptance_test
  end
  
  def teardown
    teardown_acceptance_test
  end
  
  def test_should_accept_wildcard_stub_call_without_arguments
    instance = Object.new
    test_result = run_as_test do
      instance.stubs(:to_s)
      instance.to_s
      assert_received(instance, :to_s)
      assert_matcher_accepts have_received(:to_s), instance
    end
    assert_passed(test_result)
  end

  def test_should_accept_wildcard_stub_call_with_arguments
    instance = Object.new
    test_result = run_as_test do
      instance.stubs(:to_s)
      instance.to_s(:argument)
      assert_received(instance, :to_s)
      assert_matcher_accepts have_received(:to_s), instance
    end
    assert_passed(test_result)
  end

  def test_should_not_accept_wildcard_stub_without_call
    instance = Object.new
    test_result = run_as_test do
      instance.stubs(:to_s)
      assert_received(instance, :to_s)
      assert_matcher_accepts have_received(:to_s), instance
    end
    assert_failed(test_result)
  end

  def test_should_not_accept_call_without_arguments
    instance = Object.new
    test_result = run_as_test do
      instance.stubs(:to_s)
      instance.to_s
      assert_received(instance, :to_s) {|expect| expect.with(1) }
      assert_matcher_accepts have_received(:to_s).with(1), instance
    end
    assert_failed(test_result)
  end

  def test_should_not_accept_call_with_different_arguments
    instance = Object.new
    test_result = run_as_test do
      instance.stubs(:to_s)
      instance.to_s(2)
      assert_received(instance, :to_s) {|expect| expect.with(1) }
      assert_matcher_accepts have_received(:to_s).with(1), instance
    end
    assert_failed(test_result)
  end

  def test_should_accept_call_with_correct_arguments
    instance = Object.new
    test_result = run_as_test do
      instance.stubs(:to_s)
      instance.to_s(1)
      assert_received(instance, :to_s) {|expect| expect.with(1) }
      assert_matcher_accepts have_received(:to_s).with(1), instance
    end
    assert_passed(test_result)
  end

  def test_should_accept_call_with_wildcard_arguments
    instance = Object.new
    test_result = run_as_test do
      instance.stubs(:to_s)
      instance.to_s('hello')
      assert_received(instance, :to_s) {|expect| expect.with(is_a(String)) }
      assert_matcher_accepts have_received(:to_s).with(is_a(String)), instance
    end
    assert_passed(test_result)
  end

  def test_should_reject_call_on_different_mock
    instance = Object.new
    other    = Object.new
    test_result = run_as_test do
      instance.stubs(:to_s)
      other.stubs(:to_s)
      other.to_s('hello')
      assert_received(instance, :to_s) {|expect| expect.with(is_a(String)) }
      assert_matcher_accepts have_received(:to_s).with(is_a(String)), instance
    end
    assert_failed(test_result)
  end

  def test_should_accept_correct_number_of_calls
    instance = Object.new
    test_result = run_as_test do
      instance.stubs(:to_s)
      2.times { instance.to_s }
      assert_received(instance, :to_s) {|expect| expect.twice }
      assert_matcher_accepts have_received(:to_s).twice, instance
    end
    assert_passed(test_result)
  end

  def test_should_reject_incorrect_number_of_calls
    instance = Object.new
    test_result = run_as_test do
      instance.stubs(:to_s)
      instance.to_s
      assert_received(instance, :to_s) {|expect| expect.twice }
      assert_matcher_accepts have_received(:to_s).twice, instance
    end
    assert_failed(test_result)
  end

end
