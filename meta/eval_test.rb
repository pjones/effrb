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
class EvalTest < MiniTest::Unit::TestCase

  ##############################################################################
  def test_eval_widget
    w = EvalExamples::Widget.new("foo")
    assert_equal("foo", w.instance_eval {@name})
  end

  ##############################################################################
  def test_ieval_widget
    w = InstanceEvalWidget::Widget.new {|x| x.name = "foo"}
    assert_equal("foo", w.name)
  end

  ##############################################################################
  def test_reset
    assert_equal(0, ResetWithEval.reset)
    assert_equal(1, ResetWithExec.reset)
  end
end
