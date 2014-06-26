################################################################################
# This file is part of the package effrb. It is subject to the license
# terms in the LICENSE.md file found in the top-level directory of
# this distribution and at https://github.com/pjones/effrb. No part of
# the effrb package, including this file, may be copied, modified,
# propagated, or distributed except according to the terms contained
# in the LICENSE.md file.

################################################################################
require(File.expand_path('../lib/test.rb', File.dirname(__FILE__)))
require(File.expand_path('../lib/tools.rb', File.dirname(__FILE__)))
require('irb')

################################################################################
class IRBTest < MiniTest::Unit::TestCase

  ##############################################################################
  class Commands
    include(IRB::ExtendCommandBundle)
  end

  ##############################################################################
  def test_irb_config_auto_indent
    # <<: auto-indent
    IRB.conf[:AUTO_INDENT] = true
    # :>>
    assert(IRB.conf[:AUTO_INDENT])
  end

  ##############################################################################
  def test_time_command
    puts_called = false

    c = Commands.new
    c.define_singleton_method(:puts) {|*| puts_called = true}

    result = c.time {1+1}
    assert_equal(2, result)
    assert(puts_called)
  end
end
