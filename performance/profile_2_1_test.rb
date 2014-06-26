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
class ProfileTest < MiniTest::Unit::TestCase

  ##############################################################################
  def memory_trace_start
    # <<: objspace-start
    require("objspace")

    # Start collecting allocation information.
    ObjectSpace.trace_object_allocations_start
    # :>>
  end

  ##############################################################################
  def memory_trace_record
    # <<: objspace-record
    # Force garbage collector to run.
    GC.start

    # Write current statistics to a file.
    File.open("memory.json", "w") do |file|
      ObjectSpace.dump_all(output: file)
    end
    # :>>
  end

  ##############################################################################
  def memory_trace_end
    # <<: objspace-end
    # Stop collecting allocation information.
    ObjectSpace.trace_object_allocations_stop
    # :>>
  end

  ##############################################################################
  def test_memory_trace
    memory_trace_start
    memory_trace_record
    memory_trace_end

    assert(File.exist?('memory.json'))
    File.unlink('memory.json')
  end
end
