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
module StructOrHash

  ##############################################################################
  ITERATIONS = 1_000_000

  ##############################################################################
  St = Struct.new(:a, :b)

  ##############################################################################
  def self.struct
    s = St.new(1, 2)

    ITERATIONS.times do
      s.a
      s.b += 1
    end
  end

  ##############################################################################
  def self.ostruct
    o = OpenStruct.new(:a => 1, :b  => 2)

    ITERATIONS.times do
      o.a
      o.b += 1
    end
  end

  ##############################################################################
  def self.hash
    h = Hash[:a, 1, :b, 2] # Try to level the playing field with St.

    ITERATIONS.times do
      h[:a]
      h[:b] += 1
    end
  end

  ##############################################################################
  def self.run
    Benchmark.bmbm do |bm|
      bm.report(" struct:") {struct}
      bm.report("ostruct:") {ostruct}
      bm.report("   hash:") {hash}
    end
  end
end

################################################################################
StructOrHash.run
