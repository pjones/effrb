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
class StructTest < MiniTest::Unit::TestCase

  ##############################################################################
  DATA_FILE = File.expand_path('../data/weather.csv', File.dirname(__FILE__))
  MEAN      = 53.4

  ##############################################################################
  module UsingHash
    # <<: hash-weather
    require('csv')

    class AnnualWeather
      def initialize (file_name)
        @readings = []

        CSV.foreach(file_name, headers: true) do |row|
          @readings << {
            :date => Date.parse(row[2]),
            :high => row[10].to_f,
            :low  => row[11].to_f,
          }
        end
      end
    end
    # :>>

    class AnnualWeather
      # <<: hash-mean
      def mean
        return 0.0 if @readings.size.zero?

        total = @readings.reduce(0.0) do |sum, reading|
          sum + (reading[:high] + reading[:low]) / 2.0
        end

        total / @readings.size.to_f
      end
      # :>>
    end
  end

  ##############################################################################
  module UsingStruct
    # <<: struct-weather
    require('csv')

    class AnnualWeather
      # Create a new struct to hold reading data.
      Reading = Struct.new(:date, :high, :low)

      def initialize (file_name)
        @readings = []

        CSV.foreach(file_name, headers: true) do |row|
          @readings << Reading.new(Date.parse(row[2]),
                                   row[10].to_f,
                                   row[11].to_f)
        end
      end
    end
    # :>>

    class AnnualWeather
      # <<: struct-mean
      def mean
        return 0.0 if @readings.size.zero?

        total = @readings.reduce(0.0) do |sum, reading|
          sum + (reading.high + reading.low) / 2.0
        end

        total / @readings.size.to_f
      end
      # :>>
    end
  end

  ##############################################################################
  module WithMethods
    class AnnualWeather
      require('csv')

      # <<: methods-reading
      Reading = Struct.new(:date, :high, :low) do
        def mean
          (high + low) / 2.0
        end
      end
      # :>>

      def initialize (file_name)
        @readings = []

        CSV.foreach(file_name, headers: true) do |row|
          @readings << Reading.new(Date.parse(row[2]),
                                   row[10].to_f,
                                   row[11].to_f)
        end
      end
    end

    class AnnualWeather
      # <<: methods-mean
      def mean
        return 0.0 if @readings.size.zero?

        total = @readings.reduce(0.0) do |sum, reading|
          sum + reading.mean
        end

        total / @readings.size.to_f
      end
      # :>>
    end
  end

  ##############################################################################
  def test_weather
    [ UsingHash::AnnualWeather,
      UsingStruct::AnnualWeather,
      WithMethods::AnnualWeather,
    ].each do |klass|
      weather = klass.new(DATA_FILE)
      assert_equal(MEAN, weather.mean)
    end
  end
end
