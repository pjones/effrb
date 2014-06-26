################################################################################
# This file is part of the package effrb. It is subject to the license
# terms in the LICENSE.md file found in the top-level directory of
# this distribution and at https://github.com/pjones/effrb. No part of
# the effrb package, including this file, may be copied, modified,
# propagated, or distributed except according to the terms contained
# in the LICENSE.md file.

################################################################################
# <<: require
require('minitest/autorun')
# :>>

################################################################################
# All the test file to work from this directory and the fake test dir.
begin
  dir = File.dirname(__FILE__)

  if dir.match(/test$/)
    require(File.expand_path('../../lib/oop.rb', dir))
  else
    require(File.expand_path('../lib/oop.rb', dir))
  end
end

################################################################################
# Empty class to show off how to define a unit test.
# <<: class
class VersionTest < MiniTest::Unit::TestCase
  # ...
end
# :>>

################################################################################
# Now the real class.
class VersionTest

  # Bring in the Version class we wish to test.
  include(GoodVersion)

  # <<: setup
  def setup
    @v1 = Version.new("2.1.1")
    @v2 = Version.new("2.3.0")
  end
  # :>>

  # <<: test-assert
  def test_major_number
    v = Version.new("2.1.3")
    assert(v.major == 2, "major should be 2")
  end
  # :>>

  # <<: test-parse
  def test_can_parse_version_string
    v = Version.new("2.1.3")
    assert_equal(2, v.major, "major")
    assert_equal(1, v.minor, "minor")
    assert_equal(3, v.patch, "patch")
  end
  # :>>

  # <<: test-compare
  def test_version_compare
    refute_equal(@v1, @v2)
    assert_operator(@v1, :<, @v2)
  end
  # :>>
end
