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
class CoverageTest < MiniTest::Unit::TestCase

  ##############################################################################
  class Widget
    def seed (*); end

    # <<: widget-update
    def update (location)
      @status = location.description
    end
    # :>>
  end

  ##############################################################################
  def test_widget_seed
    # <<: widget-seed
    w = Widget.new
    w.seed(:name)
    # :>>
    assert(w)

    location = MiniTest::Mock.new
    location.expect(:description, "Foo")
    assert("Foo", w.update(location))
    location.verify
  end
end

################################################################################
# <<: version
class Version
  def initialize (version)
    @major, @minor, @patch =
      version.split('.').map(&:to_i)
  end

  def to_s
    [@major, @minor, @patch].join('.')
  end
end
# :>>

################################################################################
# <<: property
require('mrproper')

properties("Version") do
  data([Integer, Integer, Integer])

  property("new(str).to_s == str") do |data|
    str = data.join('.')
    assert_equal(str, Version.new(str).to_s)
  end
end
# :>>
