# coding: utf-8

################################################################################
# This file is part of the package effrb. It is subject to the license
# terms in the LICENSE.md file found in the top-level directory of
# this distribution and at https://github.com/pjones/effrb. No part of
# the effrb package, including this file, may be copied, modified,
# propagated, or distributed except according to the terms contained
# in the LICENSE.md file.

################################################################################
$LOAD_PATH.unshift(File.expand_path('../lib', File.dirname(__FILE__)))
require('inspect.rb')

################################################################################
IRB.conf[:PROMPT][:CUSTOM] = {
  :PROMPT_I => "irb> ",
  :PROMPT_S => "%l>> ",
  :PROMPT_C => "     ",
  :PROMPT_N => "     ",
  :RETURN => "---> %s\n\n"
}

################################################################################
IRB.conf[:PROMPT_MODE] = :CUSTOM
IRB.conf[:AUTO_INDENT] = false

################################################################################
# Turn on warnings.
$VERBOSE = true

################################################################################
require('pp')

################################################################################
Array.class_exec do
  def inspect
    items = map(&:inspect)

    if items.reduce(0) {|a, i| a + i.length} > 50
      '[ ' + items.join(",\n       ") + ' ]'
    else
      '[' + items.join(', ') + ']'
    end
  end
end

################################################################################
Hash.class_exec do
  alias_method(:orig_inspect, :inspect)

  def inspect
    return orig_inspect if ENV['RUBY_HIDE_HASH'].nil?
    "{#{ENV['RUBY_HIDE_HASH']}}"
  end
end

################################################################################
Proc.class_exec do
  def inspect
    super.sub(/:0x\w+/, '')
  end
end

################################################################################
# Hack in non-interactive sub-sessions.
module IRB::ExtendCommandBundle
  alias_method(:orig_irb, :irb)

  def irb (*obj)
    $VERBOSE = false
    ws = IRB::WorkSpace.new(*obj)
    context.instance_variable_set(:@workspace, ws)
    context.prompt_i = 'irb#1> '
    context.return_format = "--" + context.return_format
    $VERBOSE = true
    nil
  end
end
