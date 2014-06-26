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
class PerlismsTest < MiniTest::Unit::TestCase

  ##############################################################################
  module Perl
    # <<: perl_extract_error
    def extract_error (message)
      if message =~ /^ERROR:\s+(.+)$/
        $1
      else
        "no error"
      end
    end
    # :>>

    module_function(:extract_error)
  end

  ##############################################################################
  def test_perl_extract
    assert_equal("foo", Perl.extract_error("ERROR: foo"))
    refute($1) # It's not really global.
    assert_equal("no error", Perl.extract_error("pancake"))
  end

  ##############################################################################
  module Better
    # <<: better_extract_error
    def extract_error (message)
      if m = message.match(/^ERROR:\s+(.+)$/)
        m[1]
      else
        "no error"
      end
    end
    # :>>

    module_function(:extract_error)
  end

  ##############################################################################
  def test_better_extract
    assert_equal("foo", Better.extract_error("ERROR: foo"))
    assert_equal("no error", Better.extract_error("pancake"))
  end

  ##############################################################################
  def test_english
    # <<: english
    require('English')
    # :>>

    assert_equal($;, $FS)
  end

  ##############################################################################
  def point_free
    # <<: point_free
    while readline
      print if ~ /^ERROR:/
    end
    # :>>
  end

  ##############################################################################
  def test_point_free
    require('stringio')

    io = StringIO.new("ERROR: foo\n")
    stdin, $stdin = $stdin, io
    assert_output("ERROR: foo\n") do
      begin
        point_free
      rescue EOFError
      end
    end
  ensure
    $stdin = stdin if stdin
  end
end
