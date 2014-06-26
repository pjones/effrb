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
module WithoutArgs
  # <<: parent-noargs
  class Parent
    attr_accessor(:name)

    def initialize
      @name = "Howard"
    end
  end
  # :>>

  # <<: child-noargs
  class Child < Parent
    attr_accessor(:grade)

    def initialize
      @grade = 8
    end
  end
  # :>>

  class Parent
    # Hide the module.
    include(BookInspect)
  end
end

################################################################################
module WithArgs
  # <<: parent-args
  class Parent
    def initialize (name)
      @name = name
    end
  end
  # :>>

  class Parent
    attr_accessor(:name)
  end

  # <<: child-args
  class Child < Parent
    def initialize (grade)
      @grade = grade
    end
  end
  # :>>

  class Parent
    # Hide the module.
    include(BookInspect)
  end

  class Child
    attr_accessor(:grade)
  end
end

################################################################################
module UsingSuper
  # <<: parent-super
  class Parent
    attr_accessor(:name)

    def initialize (name)
      @name = name
    end
  end
  # :>>

  # <<: child-super
  class Child < Parent
    def initialize (name, grade)
      super(name) # Initialize Parent.
      @grade = grade
    end
  end
  # :>>

  class Parent
    # Hide the module.
    include(BookInspect)
  end

  class Child
    attr_accessor(:grade)
  end
end
