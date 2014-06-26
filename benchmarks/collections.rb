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
require('set')

################################################################################
module FastestCollection

  ##############################################################################
  ELEMENTS = 1_000_000
  ITERATIONS = 100

  ##############################################################################
  def self.array
    (1..ELEMENTS).to_a.map(&:to_s)
  end

  ##############################################################################
  def self.hash
    Hash[array.zip((1..ELEMENTS).to_a)]
  end

  ##############################################################################
  def self.range
    1..ELEMENTS
  end

  ##############################################################################
  def self.set
    Set.new(array)
  end

  ##############################################################################
  def self.run
    array_ = array
    hash_  = hash
    range_ = range
    set_   = set
    key    = (ELEMENTS - 1).to_s

    Benchmark.bmbm do |bm|
      bm.report(" array:") {ITERATIONS.times {array_.include?(key)}}
      bm.report("  hash:") {ITERATIONS.times {hash_.include?(key)}}
      bm.report(" range:") {ITERATIONS.times {range_.include?(ELEMENTS - 1)}}
      bm.report("   set:") {ITERATIONS.times {set_.include?(key)}}
    end
  end
end

################################################################################
FastestCollection.run
