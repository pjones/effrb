#!/usr/bin/env ruby -w

################################################################################
# This file is part of the package effrb. It is subject to the license
# terms in the LICENSE.md file found in the top-level directory of
# this distribution and at https://github.com/pjones/effrb. No part of
# the effrb package, including this file, may be copied, modified,
# propagated, or distributed except according to the terms contained
# in the LICENSE.md file.

################################################################################
class Worker

  ##############################################################################
  LOOPS = 1_000

  ##############################################################################
  def initialize (name, &block)
    stat_a = GC.stat
    LOOPS.times(&block)
    stat_b = GC.stat

    before = stat_a[:total_allocated_object] || 0
    after  = stat_b[:total_allocated_object] || 0

    # The `times` method creates one object.
    after -= 1 if after > 0

    diff   = (after - before).to_s.rjust(6, ' ')
    $stdout.puts(name.rjust(15, ' ') + ': ' + diff)
  end
end

Worker.new("nothing")        {}
Worker.new("int")            {1}
Worker.new("[int]")          {[1, 2, 3]}
Worker.new("[int].freeze")   {[1, 2, 3].freeze}
Worker.new("[str]")          {%w(a b c)}
Worker.new("[str].freeze")   {%w(a b c).freeze}
Worker.new("{int}")          {{1 => 2}}
Worker.new("{int}.freeze")   {{1 => 2}.freeze}
Worker.new("string")         {"abc"}
Worker.new("string.freeze")  {"abc".freeze}
Worker.new("string.freeze2") {"abc".freeze}
