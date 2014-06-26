################################################################################
# This file is part of the package effrb. It is subject to the license
# terms in the LICENSE.md file found in the top-level directory of
# this distribution and at https://github.com/pjones/effrb. No part of
# the effrb package, including this file, may be copied, modified,
# propagated, or distributed except according to the terms contained
# in the LICENSE.md file.


# <<: class
# Represents a version number with three components:
#
# * Major number  (1 in +1.2.3+)
# * Minor number: (2 in +1.2.3+)
# * Patch level:  (3 in +1.2.3+)
#
# Example:
#   v = Version.new("10.9.16")
#   v.major # => 10
class Version
  # ...
end
# :>>

class Version
  # <<: method
  # Parses the given version string and creates
  # a new Version object.
  def initialize (version)
    # ...
  end
  # :>>
end
