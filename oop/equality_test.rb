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
class EqualityTest < MiniTest::Unit::TestCase

  ##############################################################################
  class FakeInterface

    ############################################################################
    class InvalidCommandError < StandardError; end

    ############################################################################
    def start;     :start; end
    def stop;      :stop;  end
    def cd (dir);  dir;    end
    def timer (n); n;      end

    ############################################################################
    def eval (command)
      # <<: case
      case command
      when "start"        then start
      when "stop", "quit" then stop
      when /^cd\s+(.+)$/  then cd($1)
      when Numeric        then timer(command)
      else raise(InvalidCommandError, command)
      end
      # :>>
    end

    ############################################################################
    def eval_long (command)
      # <<: long
      if    "start" === command       then start
      elsif "stop"  === command       then stop
      elsif "quit"  === command       then stop
      elsif /^cd\s+(.+)$/ === command then cd($1)
      elsif Numeric === command       then timer(command)
      else  raise(InvalidCommandError, command)
      end
      # :>>
    end
  end

  ##############################################################################
  Command = Struct.new(:send, :expect)

  ##############################################################################
  def test_command_interpreter
    x = FakeInterface.new

    [ Command.new("start",  :start),
      Command.new("stop",   :stop),
      Command.new("quit",   :stop),
      Command.new("cd foo", "foo"),
      Command.new(1, 1)

    ].each do |c|
      assert_equal(c.expect, x.eval(c.send))
      assert_equal(c.expect, x.eval_long(c.send))
    end
  end
end
