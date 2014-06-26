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
module WhoAmIWithPrepend

  module A
    def who_am_i?
      "A#who_am_i?"
    end
  end

  module B
    def who_am_i?
      "B#who_am_i?"
    end
  end

  # <<: c-using-prepend
  class C
    prepend(A)
    prepend(B)

    def who_am_i?
      "C#who_am_i?"
    end
  end
  # :>>

  module A; include(BookInspect); end
  module B; include(BookInspect); end
  class C; include(BookInspect); end
end
