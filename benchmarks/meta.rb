#!/usr/bin/env ruby -w

################################################################################
# This file is part of the package effrb. It is subject to the license
# terms in the LICENSE.md file found in the top-level directory of
# this distribution and at https://github.com/pjones/effrb. No part of
# the effrb package, including this file, may be copied, modified,
# propagated, or distributed except according to the terms contained
# in the LICENSE.md file.

################################################################################
require('benchmark')
require('ostruct')

################################################################################
module MethodMissing

  ##############################################################################
  ITERATIONS = 1_000_000

  ##############################################################################
  class Silly
    def one; 1; end
    def method_missing (*); 2; end
  end

  ##############################################################################
  def self.run
    obj = Silly.new

    Benchmark.bmbm do |bm|
      bm.report(" one:") {ITERATIONS.times {obj.one}}
      bm.report(" two:") {ITERATIONS.times {obj.two}}
    end
  end
end

################################################################################
MethodMissing.run
