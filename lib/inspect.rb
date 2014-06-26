################################################################################
# This file is part of the package effrb. It is subject to the license
# terms in the LICENSE.md file found in the top-level directory of
# this distribution and at https://github.com/pjones/effrb. No part of
# the effrb package, including this file, may be copied, modified,
# propagated, or distributed except according to the terms contained
# in the LICENSE.md file.

################################################################################
require('pp')

################################################################################
module BookInspect
  def self.included (klass)
    klass.class_eval do
      class << self;
        alias_method(:to_s_without_book_inspect, :to_s)
      end
    end

    klass.extend(BookInspect::ClassMethods)
    klass.extend(BookInspect)
  end

  def inspect
    super.gsub(/\w+::/, '').sub(/:0x\w+/, '')
  end

  module ClassMethods
    HIDE = [PP::ObjectMixin, BookInspect]

    def to_s
      super.gsub(/\w+::/, '')
    end

    def ancestors
      hide = HIDE.dup

      mod = to_s_without_book_inspect.split('::')
      mod.pop

      while !mod.size.zero?
        hide << const_get(mod.join('::').to_sym)
        mod.pop
      end

      super.reject {|m| hide.include?(m)}
    end
  end
end
