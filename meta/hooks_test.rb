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
class HooksTest < MiniTest::Unit::TestCase

  ##############################################################################
  # <<: super-forwardable
  module SuperForwardable
    # Module hook.
    def self.extended (klass)
      require('forwardable')
      klass.extend(Forwardable)
    end

    # Creates delegator which calls super.
    def def_delegators_with_super (target, *methods)
      methods.each do |method|
        target_method = "#{method}_without_super".to_sym
        def_delegator(target, method, target_method)

        define_method(method) do |*args, &block|
          send(target_method, *args, &block)
          super(*args, &block)
        end
      end
    end
  end
  # :>>

  ##############################################################################
  class TestParent
    attr_accessor(:one_called, :two_called)

    def one; self.one_called = true; end
    def two; self.two_called = true; end
  end

  class TestChild < TestParent
    attr_reader(:target)
    extend(SuperForwardable)
    def_delegators_with_super(:@target, :one, :two)
    def initialize; @target = TestParent.new; end
  end

  ##############################################################################
  def test_child
    child = TestChild.new
    child.one
    child.two

    assert(child.one_called)
    assert(child.two_called)
    assert(child.target.one_called)
    assert(child.target.two_called)
  end

  ##############################################################################
  # <<: raising-hash
  class RaisingHash
    extend(SuperForwardable)
    def_delegators(:@hash, :[], :[]=) # etc.
    def_delegators_with_super(:@hash, :freeze, :taint, :untaint)

    def initialize
      # Create @hash...
    end
  end
  # :>>

  class RaisingHash
    attr_reader(:hash)

    $OLD_VERBOSE, $VERBOSE = $VERBOSE, nil

    def initialize
      @hash = Hash.new do |hash, key|
        raise(KeyError, "invalid key `#{key}'!")
      end
    end

    $VERBOSE = $OLD_VERBOSE
  end

  ##############################################################################
  def test_raising_hash
    r = RaisingHash.new
    r.freeze
    assert(r.frozen?)
    assert(r.hash.frozen?)
  end

  ##############################################################################
  def test_prevent_inheritance
    parent = Class.new
    parent.extend(PreventInheritance)

    assert_raises(PreventInheritance::InheritanceError) do
      Class.new(parent)
    end
  end

  ##############################################################################
  # <<: parent-inherited
  class Parent
    def self.inherited (child)
      # ..
    end
  end
  # :>>

  ##############################################################################
  def test_parent
    assert(Parent.new)
  end

  ##############################################################################
  # <<: instance-watcher
  class InstanceMethodWatcher
    def self.method_added     (m); end
    def self.method_removed   (m); end
    def self.method_undefined (m); end

    # Triggers method_added(:hello)
    def hello; end

    # Triggers method_removed(:hello)
    remove_method(:hello)

    # Triggers method_added(:hello), again.
    def hello; end

    # Triggers method_undefined(:hello)
    undef_method(:hello)
  end
  # :>>

  ##############################################################################
  def test_instance_method_watcher
    assert(InstanceMethodWatcher.new)
  end

  ##############################################################################
  # <<: singleton-watcher
  class SingletonMethodWatcher
    def self.singleton_method_added     (m); end
    def self.singleton_method_removed   (m); end
    def self.singleton_method_undefined (m); end

    # Triggers singleton_method_added(:hello)
    def self.hello; end

    # Triggers singleton_method_removed(:hello)
    class << self; remove_method(:hello); end

    # Triggers singleton_method_removed(:hello), again.
    def self.hello; end

    # Triggers singleton_method_undefined(:hello)
    class << self; undef_method(:hello); end
  end
  # :>>

  ##############################################################################
  def test_singleton_method_watcher
    assert(SingletonMethodWatcher.new)
  end
end
