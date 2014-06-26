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
class VexingParseTest < MiniTest::Unit::TestCase

  ##############################################################################
  module Bad
    # <<: bad-counter
    class Counter
      attr_accessor(:counter)

      def initialize
        counter = 0
      end
      # ...
    end
    # :>>

    # <<: bad-name
    class Name
      attr_accessor(:first, :last)

      def initialize (first, last)
        self.first = first
        self.last  = last
      end

      def full
        self.first + " " + self.last
      end
    end
    # :>>
  end

  ##############################################################################
  module Good
    # <<: good-counter
    class Counter
      attr_accessor(:counter)

      def initialize
        self.counter = 0
      end
      # ...
    end
    # :>>

    ############################################################################
    class Name
      attr_accessor(:first, :last)

      def initialize (first, last)
        self.first = first
        self.last  = last
      end

      # <<: good-name
      def full
        first + " " + last
      end
      # :>>
    end
  end

  ##############################################################################
  def test_counter_class
    bc = Bad::Counter.new
    assert_equal(nil, bc.counter)

    bc.counter = 1
    assert_equal(1, bc.counter)

    gc = Good::Counter.new
    assert_equal(0, gc.counter)
  end

  ##############################################################################
  def test_name
    bn = Bad::Name.new("Kyle", "Gilpatric")
    assert_equal("Kyle Gilpatric", bn.full)

    gn = Good::Name.new("Jordan", "Jones")
    assert_equal("Jordan Jones", gn.full)
  end
end
