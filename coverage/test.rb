################################################################################
# This file is part of the package effrb. It is subject to the license
# terms in the LICENSE.md file found in the top-level directory of
# this distribution and at https://github.com/pjones/effrb. No part of
# the effrb package, including this file, may be copied, modified,
# propagated, or distributed except according to the terms contained
# in the LICENSE.md file.

################################################################################
require('simplecov')
SimpleCov.start

################################################################################
require('minitest/autorun')
require('./widget.rb')

################################################################################
class WidgetTest < MiniTest::Unit::TestCase

  ##############################################################################
  def test_can_set_name
    w = Widget.new("Foo")
    assert_equal("Foo", w.name)
  end
end
