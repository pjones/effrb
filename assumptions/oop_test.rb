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
class OOPAssumptionTests < MiniTest::Unit::TestCase

  ##############################################################################
  module ModA; def method_a () return :mod_a end; end
  module ModB; def method_b () return :mod_b end; end

  ##############################################################################
  class ClsA
    # Bring in methods from a module before they are defined in the
    # class.  Order doesn't matter, but the tests below confirm for
    # all recent versions of Ruby.
    include(ModA)

    def method_a
      return :cls_a
    end

    def method_b
      return :cls_a
    end

    # Bring in methods from a module after they have already been
    # defined in the class.  See note above.
    include(ModB)
  end

  ##############################################################################
  def test_class_before_module
    # Test that modules are one level above a class in the hierarchy.
    cls_a = ClsA.new
    assert_equal(:cls_a, cls_a.method_a)
    assert_equal(:cls_a, cls_a.method_b)

    # Make sure the methods are actually reachable.
    cls_b = Class.new
    cls_b.send(:include, ModA)
    assert_equal(:mod_a, cls_b.new.method_a)
  end

  ##############################################################################
  class Parent
    attr_accessor(:var)
    def initialize (x=0) @var = x; end
  end

  ##############################################################################
  class ChildA < Parent
    def initialize (x) super; end
  end

  ##############################################################################
  class ChildB < Parent
    def initialize (x) super(x); end
  end

  ##############################################################################
  class ChildC < Parent
    def initialize (x) super(); end
  end

  ##############################################################################
  def test_super_calls
    assert_equal(1, ChildA.new(1).var)
    assert_equal(1, ChildB.new(1).var)
    assert_equal(0, ChildC.new(1).var)
  end

  ##############################################################################
  class ChildD < Parent
    # no initialize.
  end

  ##############################################################################
  class SuperInMethodMissingError < StandardError; end

  ##############################################################################
  class ChildE < ChildD
    attr_reader(:foo_var)
    def initialize (*args); super; end

    def foo
      @foo_var = :in_foo
      super
    end

    def method_missing (m)
      case m
      when :foo, :bar
        raise(SuperInMethodMissingError)
      else
        super
      end
    end
  end

  ##############################################################################
  class ChildF < ChildE
    def bar
      super
    end
  end

  ##############################################################################
  def test_super_searches_up_more_than_one_level
    assert_equal(1, ChildE.new(1).var)
  end

  ##############################################################################
  def test_super_to_method_missing
    child_e = ChildE.new

    assert_raises(SuperInMethodMissingError) {child_e.foo}
    assert_equal(:in_foo, child_e.foo_var)

    # method_missing from higher in the hierarchy works too.
    assert_raises(SuperInMethodMissingError) {ChildF.new.bar}
  end

  ##############################################################################
  class BaseA
    def method_a () :base_a; end
  end

  ##############################################################################
  class DerivedA
    include(ModA)
    def method_a () super; end
  end

  ##############################################################################
  def test_super_goes_to_mod_first
    assert_equal(:mod_a, DerivedA.new.method_a)
  end

  ##############################################################################
  class BaseB
    def method_1 (x=0, &block)
      block.call(x)
    end
    def method_2 (x=0, &block)
      block.call(x)
    end
    def method_3 (x=0, &block)
      block.call(x)
    end
    def method_4 (x=0, &block)
      block.call(x)
    end
  end

  ##############################################################################
  class DerivedB < BaseB
    def method_1 (x, &block)
      super
    end
    def method_2 (x, &block)
      super(&block)
    end
    def method_3 (x, &block)
      super(x, &block)
    end
    def method_4 (x, &block)
      super {|y| block.call(y)}
    end
  end

  ##############################################################################
  def test_super_and_blocks
    assert_equal(:foo, DerivedB.new.method_1(:foo) {|x| x})
    assert_equal(0,    DerivedB.new.method_2(:bar) {|x| x})
    assert_equal(:bar, DerivedB.new.method_3(:bar) {|x| x})
    assert_equal(:bar, DerivedB.new.method_4(:bar) {|x| x})
  end

  ##############################################################################
  class Setter
    attr_reader(:foo)

    def initialize (foo)
      nowhitespace=(foo)
    end

    def nowhitespace= (foo)
      @foo = foo
    end
  end

  ##############################################################################
  def test_setter_class
    assert_equal(nil, Setter.new(1).foo)
  end

  ##############################################################################
  module UnqualifiedA
    module UnqualifiedB
      FOO = 1

      class Bar
        def self.bar
          UnqualifiedB::FOO
        end
      end
    end
  end

  ##############################################################################
  def test_partially_qualified_names
    assert_equal(UnqualifiedA::UnqualifiedB::FOO,
                 UnqualifiedA::UnqualifiedB::Bar.bar)
  end

  ##############################################################################
  class Protected1
    protected
    def foo () 1; end
  end

  ##############################################################################
  class Protected2 < Protected1
    def go (other)
      other.foo
    end
  end

  ##############################################################################
  class Protected3 < Protected2
    def go2 (other)
      other.foo
    end
  end

  ##############################################################################
  class Protected4 < Protected3
    protected
    def foo () 2; end
  end

  ##############################################################################
  def test_protected
    p2 = Protected2.new
    p3 = Protected3.new
    p4 = Protected4.new

    assert_equal(1, p2.go(p3))
    assert_equal(1, p3.go(p2))
    assert_equal(1, p3.go2(p2))
    assert_raises(NoMethodError) {p2.go(p4)}

    assert(p3.kind_of?(p2.class))
    assert(!p2.kind_of?(p3.class))

  end
end
