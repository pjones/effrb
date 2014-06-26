################################################################################
# This file is part of the package effrb. It is subject to the license
# terms in the LICENSE.md file found in the top-level directory of
# this distribution and at https://github.com/pjones/effrb. No part of
# the effrb package, including this file, may be copied, modified,
# propagated, or distributed except according to the terms contained
# in the LICENSE.md file.

################################################################################
require(File.expand_path('meta.rb', File.dirname(__FILE__)))

################################################################################
# <<: refine
module OnlySpace
  refine(String) do
    def only_space?
      # ...
    end
  end
end
# :>>

################################################################################
# A version of OnlySpace with a real implementation of only_space?.
module OnlySpace
  refine(String) do
    undef_method(:only_space?) # Silence warnings

    # Put a real version in place.
    def only_space?
      OnlySpaceModule::OnlySpace.only_space?(self)
    end
  end
end

################################################################################
module PersonWithoutBlank
  # <<: using
  class Person
    using(OnlySpace)

    def initialize (name)
      @name = name
    end

    def valid?
      !@name.only_space?
    end

    def display (io=$stdout)
      io.puts(@name)
    end
  end
  # :>>

  class PersonB < Person
    def there?
      @name.respond_to?(:only_space?)
    end
  end
end

################################################################################
using(OnlySpace)

class BarWithOnlySpace
  def bar (str)
    str.only_space?
  end
end
