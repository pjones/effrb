################################################################################
# This file is part of the package effrb. It is subject to the license
# terms in the LICENSE.md file found in the top-level directory of
# this distribution and at https://github.com/pjones/effrb. No part of
# the effrb package, including this file, may be copied, modified,
# propagated, or distributed except according to the terms contained
# in the LICENSE.md file.

################################################################################
# Some goofy stuff to let me run this code outside of MiniTest and
# make sure finalizers are called before program termination and
# ensure that I haven't trapped an object in a closure like an idiot.
if ENV['EFFRB_CHECK_FINAL']
  require('minitest/unit')
else
  require('minitest/autorun')
end

################################################################################
class FinalTest < MiniTest::Unit::TestCase

  ##############################################################################
  # <<: resource-open
  class Resource
    def self.open (&block)
      resource = new
      block.call(resource) if block
    ensure
      resource.close if resource
    end
  end
  # :>>

  # <<: resource-new
  class Resource
    # Manual (dangerous) interface.
    def initialize
      @resource = allocate_resource
      finalizer = self.class.finalizer(@resource)
      ObjectSpace.define_finalizer(self, finalizer)
    end

    def close
      ObjectSpace.undefine_finalizer(self)
      @resource.close
    end

    # Return a Proc which can be used to free a resource.
    def self.finalizer (resource)
      lambda {|id| resource.close}
    end
  end
  # :>>

  # Code not shown in the book.
  class Resource
    IR = Struct.new(:foo) do
      def close
        if ENV['EFFRB_CHECK_FINAL']
          $stdout.puts("-- FINALIZER CALLED --")
        end
      end
    end

    def allocate_resource; IR.new(1); end
  end

  ##############################################################################
  class BadResource
    # <<: bad
    def initialize
      @resource = allocate_resource

      # DON'T DO THIS!!
      finalizer = lambda {|id| @resource.close}
      ObjectSpace.define_finalizer(self, finalizer)
    end
    # :>>
  end

  ##############################################################################
  def test_resource_auto_close
    resource = Resource.new
    assert(resource)
  end
end

################################################################################
if ENV['EFFRB_CHECK_FINAL']
  class Runner
    def initialize
      loop {make; sleep(1)}
    end

    def make
      a = []
      # Generate a lot of heap pages.
      5_000_000.times {|n| a << n.to_s}
      FinalTest::Resource.new
      nil
    end
  end

  Runner.new
end
