################################################################################
# This file is part of the package effrb. It is subject to the license
# terms in the LICENSE.md file found in the top-level directory of
# this distribution and at https://github.com/pjones/effrb. No part of
# the effrb package, including this file, may be copied, modified,
# propagated, or distributed except according to the terms contained
# in the LICENSE.md file.

################################################################################
require(File.expand_path('inspect.rb', File.dirname(__FILE__)))

################################################################################
# <<: prevent-inheritance
module PreventInheritance
  class InheritanceError < StandardError; end

  def inherited (child)
    raise(InheritanceError,
          "#{child} cannot inherit from #{self}")
  end
end
# :>>


################################################################################
class Logger
  def initialize (io)
    @io = io
  end
  def info (msg)
    return if $0.match(/test_/)
    @io.puts("INFO: " + msg)
  end
end

################################################################################
module DelegationUsingMethodMissing

  ##############################################################################
  # <<: hash-missing
  class HashProxy
    def initialize
      @hash = {}
    end

    private

    def method_missing (name, *args, &block)
      if @hash.respond_to?(name)
        @hash.send(name, *args, &block)
      else
        super
      end
    end
  end
  # :>>

  class HashProxy
    include(BookInspect)
  end

  ##############################################################################
  # <<: audit-missing
  class AuditDecorator
    def initialize (object)
      @object = object
      @logger = Logger.new($stdout)
    end

    private

    def method_missing (name, *args, &block)
      @logger.info("calling `#{name}' on #{@object.inspect}")
      @object.send(name, *args, &block)
    end
  end
  # :>>

  class AuditDecorator
    extend(BookInspect)
    include(BookInspect)
  end
end

################################################################################
module DelegationUsingDefineMethod

  ##############################################################################
  # <<: hash-def
  class HashProxy
    Hash.public_instance_methods(false).each do |name|
      define_method(name) do |*args, &block|
        @hash.send(name, *args, &block)
      end
    end

    def initialize
      @hash = {}
    end
  end
  # :>>

  class HashProxy
    include(BookInspect)
  end

  ##############################################################################
  # <<: audit-def
  class AuditDecorator
    def initialize (object)
      @object = object
      @logger = Logger.new($stdout)

      mod = Module.new do
        object.public_methods.each do |name|
          define_method(name) do |*args, &block|
            @logger.info("calling `#{name}' on " +
                         @object.inspect)
            @object.send(name, *args, &block)
          end
        end
      end

      extend(mod)
    end
  end
  # :>>
end

################################################################################
module DelegationUsingSingletonDefineMethod

  ##############################################################################
  # <<: audit-sdef
  class AuditDecorator
    def initialize (object)
      @object = object
      @logger = Logger.new($stdout)

      @object.public_methods.each do |name|
        define_singleton_method(name) do |*args, &block|
          @logger.info("calling `#{name}' on #{@object.inspect}")
          @object.send(name, *args, &block)
        end
      end
    end
  end
  # :>>
end

################################################################################
module DelegationRespondToMissing
  class HashProxy
    def initialize; @hash = {}; end

    # <<: respond-missing
    def respond_to_missing? (name, include_private)
      @hash.respond_to?(name, include_private) || super
    end
    # :>>
  end
end

################################################################################
module EvalExamples

  ##############################################################################
  # <<: eval-widget
  class Widget
    def initialize (name)
      @name = name
    end
  end
  # :>>
end

################################################################################
module InstanceEvalWidget
  # <<: ieval-widget
  class Widget
    attr_accessor(:name, :quantity)

    def initialize (&block)
      instance_eval(&block) if block
    end
  end
  # :>>
end

################################################################################
module OnlySpaceModule
  # <<: only-space-mod
  module OnlySpace
    ONLY_SPACE_UNICODE_RE = %r/\A[[:space:]]*\z/

    def self.only_space? (str)
      if str.ascii_only?
        !str.bytes.any? {|b| b != 32 && !b.between?(9, 13)}
      else
        ONLY_SPACE_UNICODE_RE === str
      end
    end
  end
  # :>>

  # <<: only-space-inst
  module OnlySpace
    def only_space?
      # Forward to module function.
      OnlySpace.only_space?(self)
    end
  end
  # :>>

  # <<: string-extra
  require('forwardable')

  class StringExtra
    extend(Forwardable)
    def_delegators(:@string,
                   *String.public_instance_methods(false))

    def initialize (str="")
      @string = str
    end

    def only_space?
      # ...
    end
  end
  # :>>

  class StringExtra
    undef_method(:only_space?)
    def only_space?
      OnlySpace.only_space?(self)
    end
  end
end

################################################################################
module AliasLogging

  # <<: log-method
  module LogMethod
    def log_method (method)
      # Choose a new, unique name for the method.
      orig = "#{method}_without_logging".to_sym

      # Make sure name is unique.
      if instance_methods.include?(orig)
        raise(NameError, "#{orig} isn't a unique name")
      end

      # Create a new name for the original method.
      alias_method(orig, method)

      # Replace original method.
      define_method(method) do |*args, &block|
        $stdout.puts("calling method `#{method}'")
        result = send(orig, *args, &block)
        $stdout.puts("`#{method}' returned #{result.inspect}")
        result
      end
    end
  end
  # :>>

  # <<: unlog-method
  module LogMethod
    def unlog_method (method)
      orig = "#{method}_without_logging".to_sym

      # Make sure log_method was called first.
      if !instance_methods.include?(orig)
        raise(NameError, "was #{orig} already removed?")
      end

      # Remove the logging version.
      remove_method(method)

      # Put the method back to it's original name.
      alias_method(method, orig)

      # Remove the name created by log_method.
      remove_method(orig)
    end
  end
  # :>>
end

################################################################################
module SingletonWithClassVar

  # <<: singleton-class-var
  class Singleton
    private_class_method(:new, :dup, :clone)

    def self.instance
      @@single ||= new
    end
  end
  # :>>

  # <<: config-db-class-var
  class Configuration < Singleton
    # ...
  end

  class Database < Singleton
    # ...
  end
  # :>>

  class Configuration; include(BookInspect); end
  class Database; include(BookInspect); end
end

################################################################################
module SingletonWithClassIVar

  class Singleton
    # <<: singleton-class-ivar
    def self.instance
      @single ||= new
    end
    # :>>
  end

  class Configuration < Singleton; include(BookInspect); end
  class Database < Singleton; include(BookInspect); end
end

################################################################################
module SingletonMod

  # <<: singleton-mod
  require('singleton')

  class Configuration
    include(Singleton)
  end
  # :>>
end

##############################################################################
module ResetWithEval

  # <<: reset-eval
  module Reset
    def self.reset_var (object, name)
      object.instance_eval("@#{name} = DEFAULT")
    end
  end
  # :>>

  # <<: counter
  class Counter
    DEFAULT = 0
    attr_reader(:counter)

    def initialize (start=DEFAULT)
      @counter = start
    end

    def inc
      @counter += 1
    end
  end
  # :>>

  class Counter; include(BookInspect); end

  def self.reset
    # <<: resetting-with-eval
    c = Counter.new(10)
    # ...
    Reset.reset_var(c, :counter)
    # :>>
    c.counter
  end
end

##############################################################################
module ResetWithExec

  # <<: reset-exec
  module Reset
    def self.reset_var (object, name)
      object.instance_exec("@#{name}".to_sym) do |var|
        const = self.class.const_get(:DEFAULT)
        instance_variable_set(var, const)
      end
    end
  end
  # :>>

  class Foo
    DEFAULT = 1
    attr_accessor(:foo)
  end

  def self.reset
    f = Foo.new
    Reset.reset_var(f, "foo")
    f.foo
  end
end

################################################################################
module WhoAmIWithInclude

  # <<: abc-with-include
  module A
    def who_am_i?
      "A#who_am_i?"
    end
  end

  module B
    def who_am_i?
      "B#who_am_i?"
    end
  end

  class C
    include(A)
    include(B)

    def who_am_i?
      "C#who_am_i?"
    end
  end
  # :>>

  module A; include(BookInspect); end
  module B; include(BookInspect); end
  class C; include(BookInspect); end
end
