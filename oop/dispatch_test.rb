################################################################################
# This file is part of the package effrb. It is subject to the license
# terms in the LICENSE.md file found in the top-level directory of
# this distribution and at https://github.com/pjones/effrb. No part of
# the effrb package, including this file, may be copied, modified,
# propagated, or distributed except according to the terms contained
# in the LICENSE.md file.

################################################################################
require(File.expand_path('../lib/test.rb', File.dirname(__FILE__)))
require(File.expand_path('../lib/customer01.rb', File.dirname(__FILE__)))

################################################################################
class DispatchTest < MiniTest::Unit::TestCase

  ##############################################################################
  def test_customer
    # <<: customer
    customer = Customer.new
    customer.name
    # :>>
    assert(customer.respond_to?(:name))
  end

  ##############################################################################
  def test_singleton_method
    # <<: singleton
    customer = Customer.new

    def customer.name
      "Leonard"
    end
    # :>>

    assert_equal("Leonard", customer.name)
  end
end
