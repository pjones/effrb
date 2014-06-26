################################################################################
# This file is part of the package effrb. It is subject to the license
# terms in the LICENSE.md file found in the top-level directory of
# this distribution and at https://github.com/pjones/effrb. No part of
# the effrb package, including this file, may be copied, modified,
# propagated, or distributed except according to the terms contained
# in the LICENSE.md file.

################################################################################
require(File.expand_path('../lib/test.rb', File.dirname(__FILE__)))
require(File.expand_path('../lib/parent_child.rb', File.dirname(__FILE__)))

################################################################################
class InitSuperTest < MiniTest::Unit::TestCase

  ##############################################################################
  def test_init
    assert_equal(nil, WithoutArgs::Child.new.name)
    assert_equal(nil, WithArgs::Child.new(2).name)
    assert_equal("Foo", UsingSuper::Child.new("Foo", 2).name)
  end
end
