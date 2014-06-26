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
class EnsureTrickTest < MiniTest::Unit::TestCase

  ##############################################################################
  class SpecificError < StandardError; end
  class TooStrongError < StandardError; end

  ##############################################################################
  # <<: return
  def tricky
    # ...
    return 'horses'
  ensure
    return 'ponies'
  end
  # :>>

  ##############################################################################
  # <<: explicit
  def explicit
    # ...
    return 'horses'
  rescue SpecificError => e
    # Recover from the exception.
    return 'ponies'
  ensure
    # Clean up only.
  end
  # :>>

  ##############################################################################
  # <<: bare
  def hammer
    # ...
    return 'hit'
  rescue
    # Discard exceptions.
    return 'smash'
  end
  # :>>

  ##############################################################################
  def obscure
    items = %w(jasmine lilac lavender)

    # <<: next
    items.each do |item|
      begin
        raise TooStrongError if item == 'lilac'
      ensure
        next # Cancels exception, continues iteration.
      end
    end
    # :>>
  end

  ##############################################################################
  def test_ensure
    assert_equal('ponies', tricky)
    assert_equal('horses', explicit)
    assert_equal(%w(jasmine lilac lavender), obscure)
    assert_equal('hit', hammer)
  end
end
