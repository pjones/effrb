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
# <<: super-happy
class SuperHappy
  def laugh
    super
    # ...
  end
end
# :>>

################################################################################
class SuperHappy
  include(BookInspect)
end

################################################################################
# <<: setme
class SetMe
  def initialize
    @value = 0
  end

  def value # "Getter"
    @value
  end

  def value= (x) # "Setter"
    @value = x
  end
end
# :>>

class SetMe; include(BookInspect); end

################################################################################
module BadColor
  # <<: bad-color
  class Color
    def initialize (name)
      @name = name
    end
  end
  # :>>

  class Color; include(BookInspect); end
end

module GoodColor
  # <<: good-color
  class Color
    attr_reader(:name)

    def initialize (name)
      @name = name
    end

    def hash
      name.hash
    end

    def eql? (other)
      name.eql?(other.name)
    end
  end
  # :>>

  class Color; include(BookInspect); end
end

################################################################################
module BadVersion

  # <<: bad-version
  class Version
    attr_reader(:major, :minor, :patch)

    def initialize (version)
      @major, @minor, @patch =
        version.split('.').map(&:to_i)
    end
  end
  # :>>

  class Version; include(BookInspect); end
end

module GoodVersion

  # Same version parser ;)
  class Version < BadVersion::Version; end

  # <<: comparable
  class Version
    include(Comparable)
    # ...
  end
  # :>>

  class Version
    # <<: spaceship
    def <=> (other)
      return nil unless other.is_a?(Version)

      [ major <=> other.major,
        minor <=> other.minor,
        patch <=> other.patch,
      ].detect {|n| !n.zero?} || 0
    end
    # :>>
  end

  # <<: version-hash
  class Version
    # ...
    alias_method(:eql?, :==)

    def hash
      [major, minor, patch].hash
    end
  end
  # :>>

end
