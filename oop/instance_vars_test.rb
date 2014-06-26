################################################################################
# This file is part of the package effrb. It is subject to the license
# terms in the LICENSE.md file found in the top-level directory of
# this distribution and at https://github.com/pjones/effrb. No part of
# the effrb package, including this file, may be copied, modified,
# propagated, or distributed except according to the terms contained
# in the LICENSE.md file.

################################################################################
require(File.expand_path('../lib/test.rb', File.dirname(__FILE__)))
require(File.expand_path('../lib/meta.rb', File.dirname(__FILE__)))

################################################################################
class InstanceVarsTest < MiniTest::Unit::TestCase

  ##############################################################################
  def test_class_vars
    c = SingletonWithClassVar::Configuration.instance
    d = SingletonWithClassVar::Database.instance
    assert_equal(c.object_id, d.object_id)
  end

  ##############################################################################
  def test_class_ivars
    c = SingletonWithClassIVar::Configuration.instance
    d = SingletonWithClassIVar::Database.instance
    assert(c.object_id != d.object_id)
  end

  ##############################################################################
  def test_singleton_mod
    c = SingletonMod::Configuration.instance
    assert(c.is_a?(SingletonMod::Configuration))
  end
end
