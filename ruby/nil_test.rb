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
class NilTest < MiniTest::Unit::TestCase

  ##############################################################################
  def test_nil_context
    person = nil

    # <<: person
    person.save if person
    person.save if !person.nil?
    person.save unless person.nil?
    # :>>

    refute(person)
  end

  ##############################################################################
  # <<: fix_title
  def fix_title (title)
    title.to_s.capitalize
  end
  # :>>

  ##############################################################################
  def test_to_s_guard
    assert(fix_title(nil))
  end

  ##############################################################################
  def test_full_name
    first = "Peter"
    middle = nil
    last = "Jones"

    # <<: full_name
    name = [first, middle, last].compact.join(" ")
    # :>>

    assert_equal("Peter Jones", name)
  end

  ##############################################################################
  def test_orders_length
    orders = nil

    # <<: array
    count = Array(orders).size
    # :>>

    assert_equal(0, count)
  end
end
