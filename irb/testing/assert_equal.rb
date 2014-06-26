################################################################################
# This file is part of the package effrb. It is subject to the license
# terms in the LICENSE.md file found in the top-level directory of
# this distribution and at https://github.com/pjones/effrb. No part of
# the effrb package, including this file, may be copied, modified,
# propagated, or distributed except according to the terms contained
# in the LICENSE.md file.

################################################################################
require('minitest/autorun')
require(File.expand_path('../../lib/oop.rb', File.dirname(__FILE__)))


################################################################################
class VersionTest < MiniTest::Unit::TestCase
  # Bring in the Version class we wish to test.
  include(GoodVersion)

  # <<: force
  def test_force_assertion_failure
    v = Version.new("3.8.11")
    assert_equal(4, v.major, "parsing major")
  end
  # :>>
end
