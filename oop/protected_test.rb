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
class ProtectedTest < MiniTest::Unit::TestCase

  ##############################################################################
  module UsingPrivate
    class Widget
      def initialize
        @screen_x, @screen_y = 1, 1
      end
    end

    # <<: private-widget
    class Widget
      def overlapping? (other)
        x1, y1 = @screen_x, @screen_y
        x2, y2 = other.instance_eval {[@screen_x, @screen_y]}
        # ...
      end
    end
    # :>>
  end

  ##############################################################################
  module UsingProtected
    class Widget < UsingPrivate::Widget; end

    # <<: protected-widget
    class Widget
      def overlapping? (other)
        x1, y1 = screen_coordinates
        x2, y2 = other.screen_coordinates
        # ...
      end

      protected

      def screen_coordinates
        [@screen_x, @screen_y]
      end
    end
    # :>>
  end

  ##############################################################################
  def test_widget
    w1 = UsingPrivate::Widget.new
    w2 = UsingPrivate::Widget.new
    assert_equal([1,1], w1.overlapping?(w2))

    w3 = UsingProtected::Widget.new
    w4 = UsingProtected::Widget.new
    assert_equal([1,1], w3.overlapping?(w4))
  end
end
