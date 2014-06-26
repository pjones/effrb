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
require(File.expand_path('../lib/meta_2_0.rb', File.dirname(__FILE__)))

################################################################################
class PrependTest < MiniTest::Unit::TestCase

  ##############################################################################
  def test_include_and_prepend
    assert_equal("C#who_am_i?", WhoAmIWithInclude::C.new.who_am_i?)
    assert_equal("B#who_am_i?", WhoAmIWithPrepend::C.new.who_am_i?)
  end
end
