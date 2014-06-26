################################################################################
# This file is part of the package effrb. It is subject to the license
# terms in the LICENSE.md file found in the top-level directory of
# this distribution and at https://github.com/pjones/effrb. No part of
# the effrb package, including this file, may be copied, modified,
# propagated, or distributed except according to the terms contained
# in the LICENSE.md file.

################################################################################
require(File.expand_path('../lib/test.rb', File.dirname(__FILE__)))
require(File.expand_path('../lib/meta.rb', File.dirname(__FILE__)))

################################################################################
class PatchingTest < MiniTest::Unit::TestCase

  ##############################################################################
  def test_space_only_mod
    { ""       => true,
      "\n"     => true,
      "\t"     => true,
      "\r\n"   => true,
      "    "   => true,
      "f"      => false,
      "\n\nf"  => false,
      "\u00a0" => true,
    }.each do |proto, expect|
      str = proto.dup
      str.extend(OnlySpaceModule::OnlySpace)
      assert_equal(expect, str.only_space?, str)
      assert_equal(expect, OnlySpaceModule::OnlySpace.only_space?(proto))

      extra = OnlySpaceModule::StringExtra.new(proto)
      assert_equal(expect, extra.only_space?)
    end
  end

end
