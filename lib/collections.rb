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
module MutatePhone
  # <<: mutate-phone
  class PhoneNumber
    def initialize (number)
      @number = number
      clean
    end

    private

    def clean
      # Remove non-numeric characters.
      @number.gsub!(/\D+/, '')
    end
  end
  # :>>

  class PhoneNumber; include(BookInspect); end
end

################################################################################
module MutateTuner
  # <<: mutate-tuner
  class Tuner
    def initialize (presets)
      @presets = presets
      clean
    end

    private

    def clean
      # Valid frequencies end in odd digits.
      @presets.delete_if {|f| f[-1].to_i.even?}
    end
  end
  # :>>

  class Tuner; include(BookInspect); end
end


module PersistentTuner
  # <<: persistent-tuner
  class Tuner
    def initialize (presets)
      @presets = clean(presets)
    end

    private

    def clean (presets)
      presets.reject {|f| f[-1].to_i.even?}
    end
  end
  # :>>

  class Tuner
    attr_accessor(:presets)
  end
end

module DupTuner
  class Tuner < MutateTuner::Tuner
    attr_reader(:presets)
  end

  # <<: dup-tuner
  class Tuner
    def initialize (presets)
      @presets = presets.dup
      clean # Modifies the duplicate.
    end

    # ...
  end
  # :>>
end
