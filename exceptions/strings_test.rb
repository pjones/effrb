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
class StringsTest < MiniTest::Unit::TestCase

  ##############################################################################
  # <<: weak
  class CoffeeTooWeakError < StandardError; end
  # :>>

  ##############################################################################
  # <<: temp
  class TemperatureError < StandardError
    attr_reader(:temperature)

    def initialize (temperature)
      @temperature = temperature
      super("invalid temperature: #@temperature")
    end
  end
  # :>>

  ##############################################################################
  def weak_rescue
    coffee = MiniTest::Mock.new

    def coffee.drink
      raise(CoffeeTooWeakError)
    end

    logger = MiniTest::Mock.new
    logger.expect(:error, nil, [String])

    # <<: rescue-weak
    begin
      coffee.drink # Try to enjoy it.
    rescue CoffeeTooWeakError
      logger.error("another bad coffee")
      raise
    end
    # :>>

  rescue CoffeeTooWeakError
    coffee.verify
    logger.verify
    return 1
  end

  ##############################################################################
  def test_basic_raise
    assert_raises(RuntimeError) do
      # <<: string
      raise("coffee machine low on water")
      # :>>
    end

    assert_raises(RuntimeError) do
      # <<: runtime
      raise(RuntimeError, "coffee machine low on water")
      # :>>
    end
  end

  ##############################################################################
  def test_weak
    assert_raises(CoffeeTooWeakError) do
      # <<: raise-weak-simple
      raise(CoffeeTooWeakError)
      # :>>
    end

    assert_raises(CoffeeTooWeakError) do
      # <<: raise-weak-string
      raise(CoffeeTooWeakError, "coffee to water ratio too low")
      # :>>
    end

    assert_equal(1, weak_rescue)
  end

  ##############################################################################
  def test_raise_temp_no_args
    assert_raises(ArgumentError) do
      raise(TemperatureError)
    end
  end

  ##############################################################################
  def test_temp_ex
    assert_raises(TemperatureError) do
      # <<: raise-temp
      raise(TemperatureError.new(180))
      # :>>
    end

    caught = false

    begin
      raise(TemperatureError.new(99))
    rescue TemperatureError => e
      assert_equal(99, e.temperature)
      assert_equal("invalid temperature: 99", e.message)
      caught = true
    rescue
      assert(false)
    end

    assert(caught)
  end

  ##############################################################################
  def test_temp_with_string
    begin
      raise(TemperatureError.new(100), "boom!")
    rescue TemperatureError => e
      assert_equal(100, e.temperature)
    end
  end
end
