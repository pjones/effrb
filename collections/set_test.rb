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
class SetTest < MiniTest::Unit::TestCase

  ##############################################################################
  DATA_FILE = File.expand_path('../data/weather-dups.csv', File.dirname(__FILE__))

  ##############################################################################
  module UsingArray
    # <<: array
    class Role
      def initialize (name, permissions)
        @name, @permissions = name, permissions
      end

      def can? (permission)
        @permissions.include?(permission)
      end
    end
    # :>>
  end

  ##############################################################################
  module UsingHash
    # <<: hash
    class Role
      def initialize (name, permissions)
        @name = name
        @permissions = Hash[permissions.map {|p| [p, true]}]
      end

      def can? (permission)
        @permissions.include?(permission)
      end
    end
    # :>>
  end

  ##############################################################################
  module UsingSet
    # <<: set
    require('set')

    class Role
      def initialize (name, permissions)
        @name, @permissions = name, Set.new(permissions)
      end

      def can? (permission)
        @permissions.include?(permission)
      end
    end
    # :>>

    # <<: weather
    require('set')
    require('csv')

    class AnnualWeather
      Reading = Struct.new(:date, :high, :low) do
        def eql? (other) date.eql?(other.date); end
        def hash; date.hash; end
      end

      def initialize (file_name)
        @readings = Set.new

        CSV.foreach(file_name, headers: true) do |row|
          @readings << Reading.new(Date.parse(row[2]),
                                   row[10].to_f,
                                   row[11].to_f)
        end
      end
    end
    # :>>

    class AnnualWeather
      attr_reader(:readings)
      def mean
        return 0.0 if @readings.size.zero?

        total = @readings.reduce(0.0) do |sum, reading|
          sum + (reading.high + reading.low) / 2.0
        end

        total / @readings.size.to_f
      end

    end
  end

  ##############################################################################
  def test_role
    [ UsingArray::Role,
      UsingHash::Role,
      UsingSet::Role,
    ].each do |klass|
      role = klass.new(klass.to_s, [:one, :two, :three])
      assert(role.can?(:two))
      assert(!role.can?(:four))
    end
  end

  ##############################################################################
  def test_weather
    w = UsingSet::AnnualWeather.new(DATA_FILE)
    assert_equal(10, w.readings.size)
    assert_equal(53.4, w.mean)
  end
end
