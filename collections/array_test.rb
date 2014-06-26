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
class ArrayTest < MiniTest::Unit::TestCase

  ##############################################################################
  module Assumed
    # <<: assumed-array
    class Pizza
      def initialize (toppings)
        toppings.each do |topping|
          add_and_price_topping(topping)
        end
      end

      # ...
    end
    # :>>

    class Pizza
      attr_reader(:topping_count)
      def add_and_price_topping (x)
        @topping_count ||= 0
        @topping_count  += 1
      end
    end
  end

  module Forced
    class Pizza < Assumed::Pizza; end

    # <<: forced-array
    class Pizza
      def initialize (toppings)
        Array(toppings).each do |topping|
          add_and_price_topping(topping)
        end
      end

      # ...
    end
    # :>>
  end

  ##############################################################################
  def test_assumed
    assert_equal(1, Assumed::Pizza.new(["foo"]).topping_count)
    assert_raises(NoMethodError) {Assumed::Pizza.new(nil)}
  end

  ##############################################################################
  def test_forced
    assert_equal(1,   Forced::Pizza.new(["foo"]).topping_count)
    assert_equal(1,   Forced::Pizza.new("foo").topping_count)
    assert_equal(nil, Forced::Pizza.new(nil).topping_count)
  end
end
