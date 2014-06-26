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
class DelegationTest < MiniTest::Unit::TestCase

  ##############################################################################
  # <<: raising-hash
  require('forwardable')

  class RaisingHash
    extend(Forwardable)
    include(Enumerable)

    def_delegators(:@hash, :[], :[]=, :delete, :each,
                           :keys, :values, :length,
                           :empty?, :has_key?)
  end
  # :>>

  ##############################################################################
  class RaisingHash
    # <<: erase
    # Forward self.erase! to @hash.delete
    def_delegator(:@hash, :delete, :erase!)
    # :>>
  end

  ##############################################################################
  class RaisingHash
    # <<: initialize
    def initialize
      @hash = Hash.new do |hash, key|
        raise(KeyError, "invalid key `#{key}'!")
      end
    end
    # :>>

    # <<: initialize-copy
    def initialize_copy (other)
      @hash = @hash.dup
    end
    # :>>

    # <<: freeze
    def freeze
      @hash.freeze
      super
    end
    # :>>

    # <<: invert
    def invert
      other = self.class.new
      other.replace!(@hash.invert)
      other
    end

    protected

    def replace! (hash)
      hash.default_proc = @hash.default_proc
      @hash = hash
    end
    # :>>
  end

  ##############################################################################
  def test_raising_hash
    h = RaisingHash.new
    h[1] = 2

    assert_equal(2, h[1])
    assert_equal(1, h.length)
    assert_equal([1], h.keys)
    assert_equal([2], h.values)
    assert_raises(KeyError) {h[3]}
    assert_raises(KeyError) {h.dup[3]}
    assert_raises(KeyError) {h.invert[3]}

    invoked = h.reduce(false) do |bool, (k,v)|
      assert_equal(1, k)
      assert_equal(2, v)
      true
    end

    assert(invoked)
  end
end
