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
class ReduceTest < MiniTest::Unit::TestCase

  ##############################################################################
  module LongSum
    # <<: long-sum
    def sum (enum)
      enum.reduce(0) do |accumulator, element|
        accumulator + element
      end
    end
    # :>>

    module_function(:sum)
  end

  ##############################################################################
  module SumDefault
    # <<: sum-default
    def sum (enum)
      enum.reduce do |accumulator, element|
        accumulator + element
      end
    end
    # :>>

    module_function(:sum)
  end

  ##############################################################################
  module ShortSum
    # <<: short-sum
    def sum (enum)
      enum.reduce(0, :+)
    end
    # :>>

    module_function(:sum)
  end

  ##############################################################################
  def test_sum
    enum = [1, 2, 3, 4, 5]
    assert_equal(15, LongSum.sum(enum))
    assert_equal(15, SumDefault.sum(enum))
    assert_equal(15, ShortSum.sum(enum))
  end

  ##############################################################################
  module Transform

    def self.array_to_hash_with_map (array)
      # <<: array-map
      Hash[array.map {|x| [x, true]}]
      # :>>
    end

    def self.array_to_hash_with_reduce (array)
      # <<: array-reduce
      array.reduce({}) do |hash, element|
        hash.update(element => true)
      end
      # :>>
    end
  end

  ##############################################################################
  def test_transform
    array = [1, 2, 3]
    hash  = {1 => true, 2 => true, 3 => true}

    assert_equal(hash, Transform.array_to_hash_with_map(array))
    assert_equal(hash, Transform.array_to_hash_with_reduce(array))
  end

  ##############################################################################
  module SelectMap
    User = Struct.new(:age, :name)

    def self.select_and_map (users)
      # <<: user-select
      users.select {|u| u.age >= 21}.map(&:name)
      # :>>
    end

    def self.with_reduce (users)
      # <<: user-reduce
      users.reduce([]) do |names, user|
        names << user.name if user.age >= 21
        names
      end
      # :>>
    end
  end

  ##############################################################################
  def test_select_map
    users = [
      SelectMap::User.new(15, "Jordan"),
      SelectMap::User.new(88, "Orin"),
      SelectMap::User.new(15, "Kyle"),
      SelectMap::User.new(22, "Frank"),
    ]

    assert_equal(%w(Orin Frank), SelectMap.select_and_map(users))
    assert_equal(%w(Orin Frank), SelectMap.with_reduce(users))
  end

  ##############################################################################
  module BadFold
    def self.convert (array)
      # <<: bad-fold
      hash = {}

      array.each do |element|
        hash[element] = true
      end
      # :>>

      hash
    end
  end

  ##############################################################################
  def test_bad_fold
    array = [1, 2, 3]
    hash  = {1 => true, 2 => true, 3 => true}
    assert_equal(hash, BadFold.convert(array))
  end
end
