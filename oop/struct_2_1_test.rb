################################################################################
# This file is part of the package effrb. It is subject to the license
# terms in the LICENSE.md file found in the top-level directory of
# this distribution and at https://github.com/pjones/effrb. No part of
# the effrb package, including this file, may be copied, modified,
# propagated, or distributed except according to the terms contained
# in the LICENSE.md file.

################################################################################
require(File.expand_path('../lib/test.rb', File.dirname(__FILE__)))
require('csv')

################################################################################
class Struct21Test < MiniTest::Unit::TestCase

  ##############################################################################
  DATA_FILE = File.expand_path('../data/weather.csv', File.dirname(__FILE__))

  ##############################################################################
  module WithKeywords
    # <<: keywords-reading
    class AnnualWeather
      Reading = Struct.new(:date, :high, :low) do
        def initialize (date:, high:, low:)
          super(date, high, low)
        end
      end

      def initialize (file_name)
        @readings = []

        CSV.foreach(file_name, headers: true) do |row|
          @readings << Reading.new(date: Date.parse(row[2]),
                                   high: row[10].to_f,
                                    low: row[11].to_f)
        end
      end
    end
    # :>>

    class AnnualWeather
      attr_reader(:readings)
    end
  end

  ##############################################################################
  def test_weather
    w = WithKeywords::AnnualWeather.new(DATA_FILE)
    assert_equal(10, w.readings.size)
    assert_equal(19.7, w.readings.first.low)
  end
end
