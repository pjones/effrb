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
class MetaAssumptionTests < MiniTest::Unit::TestCase

  ##############################################################################
  class InstanceMethodWatcher
    def self.calls
      @@calls ||= Hash.new(0)
    end

    def self.method_added (m); calls[:added] += 1; end
    def self.method_removed (m); calls[:removed] =+ 1; end
    def self.method_undefined (m); calls[:undef] += 1; end

    def hello; end
    remove_method(:hello)

    def hello; end
    undef_method(:hello)
  end

  ##############################################################################
  def test_instance_method_watcher
    hash = InstanceMethodWatcher.calls
    assert_equal(2, hash[:added])
    assert_equal(1, hash[:removed])
    assert_equal(1, hash[:undef])
  end

  ##############################################################################
  class SingletonMethodWatcher
    def self.calls
      @@calls ||= Hash.new(0)
    end

    def self.singleton_method_added (m); calls[:added] += 1; end
    def self.singleton_method_removed (m); calls[:removed] =+ 1; end
    def self.singleton_method_undefined (m); calls[:undef] += 1; end

    def self.hello; end
    class << self; remove_method(:hello); end

    def self.hello; end
    class << self; undef_method(:hello); end
  end

  ##############################################################################
  def test_singleton_method_watcher
    hash = SingletonMethodWatcher.calls
    assert_equal(5, hash[:added]) # watch out!
    assert_equal(1, hash[:removed])
    assert_equal(1, hash[:undef])
  end

  ##############################################################################
  class MissingDelegator
    def initialize; @hash = {}; end
    def respond_to_missing? (m, *); @hash.respond_to?(m); end
    def method_missing (m, *a); @hash.send(m, *a); end
  end

  ##############################################################################
  def test_missing_delegator
    d = MissingDelegator.new
    assert(d.respond_to?(:assoc))
    assert(!d.public_methods.include?(:assoc))
  end

  ##############################################################################
  class HookClassParent
    def self.hook_class
      @hook_class ||= nil
    end

    def self.method_added (m)
      @hook_class = self
    end
  end

  ##############################################################################
  class HookClassChild < HookClassParent
    def foo; end
  end

  ##############################################################################
  def test_hook_class
    assert_equal(HookClassChild, HookClassChild.hook_class)
  end

  ##############################################################################
  class DefineMethodWithBlock
    define_method(:foo) {|*args, &block| block.call(*args)}
  end

  ##############################################################################
  def test_define_method_with_block
    obj = DefineMethodWithBlock.new
    str = "h"
    obj.foo(str) {|x| x.upcase!}
    assert_equal("H", str)
  end

  ##############################################################################
  def test_instance_eval_yields_self
    widget = InstanceEvalWidget::Widget.new {|w| w.name = "foo"}
    assert_equal("foo", widget.name)
  end

  ##############################################################################
  module IncludeA
    def foo
    end
  end

  module IncludeB
    include(IncludeA)
  end

  class IncludeC
    include(IncludeB)
    extend(IncludeB)
  end

  ##############################################################################
  def test_methods_from_module_include
    assert(IncludeC.public_instance_methods.include?(:foo))
    assert(IncludeC.respond_to?(:foo))
  end
end
