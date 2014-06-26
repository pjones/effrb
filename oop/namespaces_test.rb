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
class NamespacesTest < MiniTest::Unit::TestCase

  ##############################################################################
  # <<: binding
  class Binding
    def initialize (style, options={})
      @style = style
      @options = options
    end
  end
  # :>>

  ##############################################################################
  # <<: mod-binding
  module Notebooks
    class Binding
      # ...
    end
  end
  # :>>

  ##############################################################################
  # <<: mod-inline
  class Notebooks::Binding
    # ...
  end
  # :>>

  ##############################################################################
  def test_bindings
    # Make sure our Binding class isn't the same as ::Binding.
    assert_equal(Object::Binding, ::Binding)
    assert(::Binding != Notebooks::Binding)

    # <<: mod-use
    style = Notebooks::Binding.new
    # :>>

    assert_equal(Notebooks::Binding, style.class)
  end

  ##############################################################################
  module Unqualified
    # <<: unqualified-crypto
    module SuperDumbCrypto
      KEY = "password123"

      class Encrypt
        def initialize (key=KEY)
          # ...
        end
      end
    end
    # :>>
  end

  ##############################################################################
  module UnqualifiedBug
    # <<: nameerror-crypto
    module SuperDumbCrypto
      KEY = "password123"
    end

    class SuperDumbCrypto::Encrypt
      def initialize (key=KEY) # raises NameError
        # ...
      end
    end
    # :>>
  end

  ##############################################################################
  module Qualified
    module SuperDumbCrypto
      KEY = "password123"
    end

    # <<: qualified-crypto
    class SuperDumbCrypto::Encrypt
      def initialize (key=SuperDumbCrypto::KEY)
        # ...
      end
    end
    # :>>
  end

  ##############################################################################
  def test_supercrypto
    assert(Unqualified::SuperDumbCrypto::Encrypt.new)
    assert(Qualified::SuperDumbCrypto::Encrypt.new)
    assert_raises(NameError) {UnqualifiedBug::SuperDumbCrypto::Encrypt.new}
  end

  ##############################################################################
  module Unqualified
    # <<: bad-cluster
    module Cluster
      class Array
        def initialize (n)
          @disks = Array.new(n) {|i| "disk#{i}"}
          # Oops, wrong Array!  SystemStackError!
        end
      end
    end
    # :>>

    module Cluster
      class Array
        # Fix the code above so it works.
        Array = ::Array
        attr_reader(:disks)
      end
    end
  end

  ##############################################################################
  module Qualified
    # <<: good-cluster
    module Cluster
      class Array
        def initialize (n)
          @disks = ::Array.new(n) {|i| "disk#{i}"}
        end
      end
    end
    # :>>

    module Cluster
      class Array
        attr_reader(:disks)
      end
    end
  end

  ##############################################################################
  def test_cluster
    a = Unqualified::Cluster::Array.new(2)
    assert_equal(%w(disk0 disk1), a.disks)

    b = Qualified::Cluster::Array.new(2)
    assert_equal(%w(disk0 disk1), b.disks)
  end
end
