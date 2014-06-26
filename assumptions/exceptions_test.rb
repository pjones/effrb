################################################################################
# This file is part of the package effrb. It is subject to the license
# terms in the LICENSE.md file found in the top-level directory of
# this distribution and at https://github.com/pjones/effrb. No part of
# the effrb package, including this file, may be copied, modified,
# propagated, or distributed except according to the terms contained
# in the LICENSE.md file.

################################################################################
require(File.expand_path('../lib/test.rb', File.dirname(__FILE__)))

################################################################################
class RescueAssumptionTests < MiniTest::Unit::TestCase

  ##############################################################################
  class FakeError < StandardError; end

  ##############################################################################
  def uninitialized_vars
    x = 1
    raise("stop")
    y = 2
    z = 3
  ensure
    return [x, y, z]
  end

  ##############################################################################
  def test_uninitialized_vars
    vars = uninitialized_vars
    assert_equal([1, nil, nil], vars)
  end

  ##############################################################################
  def return_exception
    raise("1")
  ensure
    return $!.to_s
  end

  ##############################################################################
  def break_inside_ensure
    %w(hello).each do |word|
      begin
        raise("WTF?")
      ensure
        break 2
      end
    end
  end

  ##############################################################################
  def next_inside_ensure
    [3].each do |word|
      begin
        raise("WTF?")
      ensure
        next
      end
    end
  end

  ##############################################################################
  def nil_exception
    return 4
  ensure
    return $!
  end

  ##############################################################################
  def exception_type
    raise(Exception.new("foo"))
  ensure
    assert_equal(Exception, $!.class)
    return 1
  end

  ##############################################################################
  def test_ensure_clause
    assert_equal("1", return_exception)
    assert_equal(2,   break_inside_ensure)
    assert_equal([3], next_inside_ensure)
    assert_equal(nil, nil_exception)
    assert_equal(1, exception_type)
  end

  ##############################################################################
  def return_in_rescue
    raise("boom")
  rescue
    return 1
  end

  ##############################################################################
  def ensure_raise
    return 1
  rescue
    return 2
  ensure
    raise("boom")
  end

  ##############################################################################
  def raise_because_no_method_error
    nil.surely_i_dont_need_to_worry_about_this
  ensure
    return 1
  end

  ##############################################################################
  def complicated_redo
    count = 2

    [1,2,3].each do |n|
      count -= 1
      begin
        raise("boom") if count > 0
      ensure
        redo if count > 0
      end
    end

    return 1
  end

  ##############################################################################
  def complicated_flow
    catch(:foo) do
      [1, 2, 3].each do |n|
        begin
          raise("boom")
        ensure
          throw(:foo, 'hello')
        end
      end
    end
  end

  ##############################################################################
  def order_matters
    raise(RuntimeError)
  rescue StandardError
    return 1
  rescue RuntimeError
    return 2
  end

  ##############################################################################
  def return_runtime_error (x)
    assert_equal(1, x)
    RuntimeError
  end

  ##############################################################################
  def expressions_work
    x = 1
    raise(RuntimeError)
  rescue return_runtime_error(x)
    return 1
  rescue StandardError
    return 2
  end

  ##############################################################################
  def indirection_a
    raise(FakeError)
  rescue FakeError
    return 1
  end

  ##############################################################################
  def indirection_b
    raise(RuntimeError)
  rescue RuntimeError
    return indirection_a
  end

  ##############################################################################
  # Generates (SyntaxError)
  # def retry_in_bad_place
  #   begin
  #     return 1
  #   ensure
  #     retry
  #   end
  # end

  ##############################################################################
  class Helper
    attr_accessor(:ensure_called)
  end

  ##############################################################################
  def ensure_and_throw
    helper = Helper.new
    throw(:jump, helper)
  ensure
    helper.ensure_called = true
  end

  ##############################################################################
  def catch_helper
    helper = catch(:jump) do
      ensure_and_throw
      nil
    end

    assert(helper)
    assert(helper.ensure_called)
    return 1
  end

  ##############################################################################
  def test_assumptions
    assert_equal(1, return_in_rescue)
    assert_raises(RuntimeError) {ensure_raise}
    assert_equal(1, raise_because_no_method_error)
    assert_equal(1, complicated_redo)
    assert_equal('hello', complicated_flow)
    assert_equal(1, order_matters)
    assert_equal(1, expressions_work)
    assert_equal(1, indirection_b)
    assert_equal(1, catch_helper)
  end
end
