################################################################################
# This file is part of the package effrb. It is subject to the license
# terms in the LICENSE.md file found in the top-level directory of
# this distribution and at https://github.com/pjones/effrb. No part of
# the effrb package, including this file, may be copied, modified,
# propagated, or distributed except according to the terms contained
# in the LICENSE.md file.

################################################################################
require(File.expand_path('../lib/test.rb', File.dirname(__FILE__)))
require(File.expand_path('../lib/oop.rb', File.dirname(__FILE__)))

################################################################################
class ComparableTest < MiniTest::Unit::TestCase

  ##############################################################################
  Check = Struct.new(:ver, :major, :minor, :patch)

  ##############################################################################
  VERSIONS = [
    Check.new('1.0.0',  1,  0, 0),
    Check.new('1.9.1',  1,  9, 1),
    Check.new('1.11.1', 1, 11, 1),
    Check.new('2.3.0',  2,  3, 0),
  ]

  ##############################################################################
  def test_bad_version
    assert_version_parsing(BadVersion::Version)
  end

  ##############################################################################
  def test_good_version
    assert_version_parsing(GoodVersion::Version)

    def self.v (ver)
      GoodVersion::Version.new(ver)
    end

    assert(v("1.9.0") <  v("1.11.0"))
    assert(v("2.0.0") >  v("1.11.11"))
    assert(v("3.2.0") >  v("3.1.0"))
    assert(v("3.2.1") >  v("3.2.0"))
    assert(v("2.1.3") == v("2.1.3"))

    assert(v("1.1.3").hash == v("1.1.3").hash)
  end

  ##############################################################################
  private

  ##############################################################################
  def assert_version_parsing (klass)
    VERSIONS.each do |check|
      v = klass.new(check.ver)
      assert_equal(check.major, v.major)
      assert_equal(check.minor, v.minor)
      assert_equal(check.patch, v.patch)
    end
  end
end
