################################################################################
# This file is part of the package effrb. It is subject to the license
# terms in the LICENSE.md file found in the top-level directory of
# this distribution and at https://github.com/pjones/effrb. No part of
# the effrb package, including this file, may be copied, modified,
# propagated, or distributed except according to the terms contained
# in the LICENSE.md file.

################################################################################
require(File.expand_path('../lib/test.rb', File.dirname(__FILE__)))
require(File.expand_path('../lib/collections.rb', File.dirname(__FILE__)))

################################################################################
class DupTest < MiniTest::Unit::TestCase

  ##############################################################################
  def test_phone_number
    number = "1-800-CALL-MEEE"
    pn = MutatePhone::PhoneNumber.new(number)
    assert_equal('1800', number)
  end

  ##############################################################################
  def test_tuners
    presets1 = %w(90.1 106.2 88.5)
    presets2 = presets1.dup

    t1 = MutateTuner::Tuner.new(presets1)
    assert_equal(%w(90.1 88.5), presets1) # mutated

    t2 = PersistentTuner::Tuner.new(presets2)
    assert_equal(%w(90.1 106.2 88.5), presets2)
    assert_equal(%w(90.1 88.5), t2.presets)

    t3 = DupTuner::Tuner.new(presets2)
    assert_equal(%w(90.1 106.2 88.5), presets2)
    assert_equal(%w(90.1 88.5), t3.presets)
  end
end
