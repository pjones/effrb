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
class HashdefTest < MiniTest::Unit::TestCase

  ##############################################################################
  module WithOrEq
    # <<: frequency
    def frequency (array)
      array.reduce({}) do |hash, element|
        hash[element] ||= 0 # Make sure the key exists.
        hash[element] += 1  # Then increment it.
        hash                # Return the hash to reduce.
      end
    end
    # :>>

    module_function(:frequency)
  end

  ##############################################################################
  module WithDefault
    # <<: frequency-def
    def frequency (array)
      array.reduce(Hash.new(0)) do |hash, element|
        hash[element] += 1 # Increment the value.
        hash               # Return the hash to reduce.
      end
    end
    # :>>

    module_function(:frequency)
  end

  ##############################################################################
  def test_frequency
    array = [1, 2, 1, 3]
    hash  = {1 => 2, 2 => 1, 3 => 1}

    assert_equal(hash, WithOrEq.frequency(array))
    assert_equal(hash, WithDefault.frequency(array))
  end

  ##############################################################################
  module Funcs
    def self.short_eq
      hash = Hash.new(0)
      key = 1

      # <<: expand-eq
      # Short version:
      hash[key] += 1

      # Expands to:
      hash[key] = hash[key] + 1
      # :>>

      hash
    end

    def self.bad_check
      hash = {}
      key = 1

      # <<: bad-check
      if hash[key]
        # ...
      end
      # :>>

      hash
    end
  end

  ##############################################################################
  def test_funcs
    assert_equal({1=>2}, Funcs.short_eq)
    assert_equal({}, Funcs.bad_check)
  end
end
