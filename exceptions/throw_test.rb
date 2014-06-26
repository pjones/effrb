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
class ThrowTest < MiniTest::Unit::TestCase

  ##############################################################################
  def prompt_loop
    ui = MiniTest::Mock.new
    ui.expect(:prompt, "quit", [String])

    # <<: stop
    loop do
      answer = ui.prompt("command: ")
      raise(StopIteration) if answer == 'quit'
      # ...
    end
    # :>>

    ui.verify
    return 1
  end

  ##############################################################################
  def nested_loop
    player = MiniTest::Mock.new
    player.expect(:valid?, true, [String, String])

    @characters = %w(Mickey Donald Goofy)
    @colors = %w(Black  White  Red)

    # <<: nested
    begin
      @characters.each do |character|
        @colors.each do |color|
          if player.valid?(character, color)
            raise(StopIteration)
          end
        end
      end
    rescue StopIteration
      # ...
    end
    # :>>

    player.verify
    return 1
  end

  ##############################################################################
  def nested_with_catch
    player = MiniTest::Mock.new
    player.expect(:valid?, true, [String, String])

    @characters = %w(Mickey Donald Goofy)
    @colors = %w(Black  White  Red)

    # <<: jump
    match = catch(:jump) do
      @characters.each do |character|
        @colors.each do |color|
          if player.valid?(character, color)
            throw(:jump, [character, color])
          end
        end
      end
    end
    # :>>

    player.verify
    return match
  end

  ##############################################################################
  def test_book_code
    assert_equal(1, prompt_loop)
    assert_equal(1, nested_loop)
    assert_equal(['Mickey', 'Black'], nested_with_catch)
  end
end
