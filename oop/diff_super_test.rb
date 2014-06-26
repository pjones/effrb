################################################################################
# This file is part of the package effrb. It is subject to the license
# terms in the LICENSE.md file found in the top-level directory of
# this distribution and at https://github.com/pjones/effrb. No part of
# the effrb package, including this file, may be copied, modified,
# propagated, or distributed except according to the terms contained
# in the LICENSE.md file.

################################################################################
require(File.expand_path('../lib/test.rb', File.dirname(__FILE__)))
require(File.expand_path('../lib/oop.rb', File.dirname(__FILE__)))

################################################################################
class DiffSuperTest < MiniTest::Unit::TestCase

  ##############################################################################
  # <<: base
  class Base
    def m1 (x, y)
      # ...
    end
  end
  # :>>

  ##############################################################################
  class Base
    undef_method(:m1) # Silence warning.

    def m1 (x, y)
      x * y
    end

    def self.m1 (x, y)
      x + y
    end
  end

  ##############################################################################
  # <<: derived
  class Derived < Base
    def m1 (x)
      # How do you call Base.m1?
    end
  end
  # :>>

  class Derived
    undef_method(:m1) # Silence warning.

    # <<: super-m1
    def m1 (x)
      super(x, x)
      # ...
    end
    # :>>
  end

  ##############################################################################
  class StupidDerived < Base
    # <<: stupid-m1
    def m1 (x)
      Base::m1(x, x)
    end
    # :>>

    # Make it un-stupid.
    alias_method(:m2, :m1)
    def m1 (*args) super; end
  end

  ##############################################################################
  def test_super_m1
    assert_equal(4, Derived.new.m1(2))
    assert_equal(4, StupidDerived.new.m2(2))
  end

  ##############################################################################
  # <<: cool-features
  module CoolFeatures
    def feature_a
      # ...
    end
  end
  # :>>

  ##############################################################################
  # <<: vanilla
  class Vanilla
    include(CoolFeatures)

    def feature_a
      # ...
      super # CoolFeatures.feature_a
    end
  end
  # :>>

  ##############################################################################
  def test_nothing_breaks
    assert_equal(nil, Vanilla.new.feature_a)
  end

  ##############################################################################
  class SillyBase
    attr_reader(:calls)
    def initialize () @calls = 0;  end
    def m1 (x=0, y=0) @calls += 1; end
  end

  ##############################################################################
  # <<: silly
  class SuperSilliness < SillyBase
    def m1 (x, y)
      super(1, 2) # Call with 1, 2.
      super(x, y) # Call with x, y.
      super x, y  # Same as above.
      super       # Same as above.
      super()     # Call without arguments.
    end
  end
  # :>>

  ##############################################################################
  def test_super_silliness
    assert_equal(5, SuperSilliness.new.m1(1, 1))
  end

  ##############################################################################
  class SuperHappy2
    def method_missing (*args)
      super
    end
  end

  ##############################################################################
  def test_super_happy
    assert_raises(NoMethodError) {SuperHappy.new.laugh}

    # method_missing changes the error message!
    assert_raises(NoMethodError) {SuperHappy2.new.laugh}
  end
end
