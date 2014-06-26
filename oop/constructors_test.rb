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
class ConstructorsTest < MiniTest::Unit::TestCase

  ##############################################################################
  module UsingNew
    # <<: using-new
    class Transaction
      def initialize (amount)
        # ...
      end
    end
    # :>>

    class Transaction
      attr_reader(:amount)
      $OLD_VERBOSE, $VERBOSE = $VERBOSE, nil
      def initialize (amount); @amount = amount; end
      $VERBOSE = $OLD_VERBOSE
    end
  end

  ##############################################################################
  module UsingConstructors
    class Transaction < UsingNew::Transaction; end

    class Transaction
      def self.deposit (amount)
        new(amount)
      end

      def self.withdrawal (amount)
        new(-amount)
      end

      # ...
    end

    class Transaction
      private_class_method(:new)
      # ...
    end
  end

  ##############################################################################
  def test_vector
    assert_equal(1,  UsingNew::Transaction.new(1).amount)
    assert_equal(-1, UsingNew::Transaction.new(-1).amount)
    assert_equal(1,  UsingConstructors::Transaction.deposit(1).amount)
    assert_equal(-1, UsingConstructors::Transaction.withdrawal(1).amount)
  end
end
