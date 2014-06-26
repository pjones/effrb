################################################################################
# This file is part of the package effrb. It is subject to the license
# terms in the LICENSE.md file found in the top-level directory of
# this distribution and at https://github.com/pjones/effrb. No part of
# the effrb package, including this file, may be copied, modified,
# propagated, or distributed except according to the terms contained
# in the LICENSE.md file.

################################################################################
require(File.expand_path('inspect.rb', File.dirname(__FILE__)))

################################################################################
module Profiling
  # <<: wind
  require('csv')

  class WindSpeed
    attr_reader(:avg)

    def initialize (io, state)
      csv = CSV.new(io)
      @state = state
      @avg = average(csv)
    ensure
      csv.close if csv
    end

    private

    def average (csv)
      recs = csv.inject([]) do |acc, row|
        acc << row[8].to_f if row[7] == @state
        acc
      end

      recs.reduce(0.0, &:+) / recs.size.to_f
    end
  end
  # :>>

  class WindSpeed; include(BookInspect); end

  def self.profile
    require('open-uri')
    file = open('http://www.spc.noaa.gov/wcm/data/2013_wind.csv')
    wind = Profiling::WindSpeed.new(file, ARGV.first || 'CO')
    # $stdout.puts(wind.avg.to_s)
  ensure
    file.close if file
  end

  def self.profile_with_stackprof
    # Nasty hack to include this in the book but ensure that it still
    # works.
    run_me = <<-EOT
    # <<: stackprof
    require("stackprof")

    StackProf.run(out: "profile.dump") do
      # ...
    end
    # :>>
    EOT

    eval(run_me.sub('# ...', 'profile'))
  end

  def self.profile_with_memory_profiler
    # Nasty hack to include this in the book but ensure that it still
    # works.
    run_me = <<-EOT
    # <<: memory_profiler
    require("memory_profiler")

    report = MemoryProfiler.report do
      # ...
    end

    report.pretty_print
    # :>>
    EOT

    eval(run_me.sub('# ...', 'profile'))
  end
end

################################################################################
if $0 == __FILE__ || File.basename($0) == 'ruby-prof'

  if ENV['EFFRB_USE_STACKPROF']
    Profiling.profile_with_stackprof
  elsif ENV['EFFRB_USE_MEMORY_PROFILER']
    Profiling.profile_with_memory_profiler
  else
    Profiling.profile
  end
end
