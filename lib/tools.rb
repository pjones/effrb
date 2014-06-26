################################################################################
# This file is part of the package effrb. It is subject to the license
# terms in the LICENSE.md file found in the top-level directory of
# this distribution and at https://github.com/pjones/effrb. No part of
# the effrb package, including this file, may be copied, modified,
# propagated, or distributed except according to the terms contained
# in the LICENSE.md file.

################################################################################
require('irb')

# <<: time
module IRB::ExtendCommandBundle
  def time (&block)
    t1 = Time.now
    result = block.call if block
    diff = Time.now - t1
    puts("Time: " + diff.to_f.to_s)
    result
  end
end
# :>>
