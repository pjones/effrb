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
class LiteralsTest < MiniTest::Unit::TestCase

  ##############################################################################
  Error = Struct.new(:code)

  ##############################################################################
  module InLoop
    class Errors
      def fatal? (errors)
        # <<: inloop-fatal
        errors.any? {|e| %w(F1 F2 F3).include?(e.code)}
        # :>>
      end

      def fatal_str? (errors)
        # <<: inloop-fatal-str
        errors.any? {|e| e.code == "FATAL"}
        # :>>
      end
    end

    class Errors2
      def fatal? (errors)
        # <<: inloop-fatal-2
        errors.any? {|e| ["F1", "F2", "F3"].include?(e.code)}
        # :>>
      end
    end
  end

  ##############################################################################
  module OutLoop
    class Errors
      # <<: outloop-const
      FATAL_CODES = %w(F1 F2 F3).map(&:freeze).freeze

      def fatal? (errors)
        errors.any? {|e| FATAL_CODES.include?(e.code)}
      end
      # :>>

      def fatal_str? (errors)
        # <<: outloop-fatal-str
        errors.any? {|e| e.code == "FATAL".freeze}
        # :>>
      end
    end
  end

  ##############################################################################
  def test_fatal
    errors = [Error.new('A'), Error.new('B'), Error.new('F1')]

    [ InLoop::Errors,
      InLoop::Errors2,
      OutLoop::Errors,
    ].each do |klass|
      checker = klass.new
      assert(checker.fatal?(errors))
      refute(checker.fatal?(errors[0,2]))
    end
  end

  ##############################################################################
  def test_fatal_str
    errors = [Error.new('WARN'), Error.new('INFO'), Error.new('FATAL')]

    [ InLoop::Errors,
      OutLoop::Errors,
    ].each do |klass|
      checker = klass.new
      assert(checker.fatal_str?(errors))
      refute(checker.fatal_str?(errors[0, 2]))
    end
  end

  ##############################################################################
  def test_w_or_split
    a = %w(F1 F2 F3)

    b = begin
          # <<: split
          "F1 F2 F3".split
          # :>>
        end

    assert_equal(a, b)
  end
end
