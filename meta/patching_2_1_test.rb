################################################################################
# This file is part of the package effrb. It is subject to the license
# terms in the LICENSE.md file found in the top-level directory of
# this distribution and at https://github.com/pjones/effrb. No part of
# the effrb package, including this file, may be copied, modified,
# propagated, or distributed except according to the terms contained
# in the LICENSE.md file.

################################################################################
require(File.expand_path('../lib/test.rb', File.dirname(__FILE__)))
require(File.expand_path('../lib/meta_2_1.rb', File.dirname(__FILE__)))

################################################################################
# Ruby 2.1 only.
class Patching21Test < MiniTest::Unit::TestCase

  ##############################################################################
  def test_refinement_worked
    # In class `using'.
    assert(PersonWithoutBlank::Person.new("F").valid?)
    assert(PersonWithoutBlank::PersonB.new("F").valid?)
    assert(!PersonWithoutBlank::PersonB.new("F").there?)

    # Top-level `using'.
    assert(BarWithOnlySpace.new.bar(""))
  end
end
