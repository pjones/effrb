################################################################################
# This file is part of the package effrb. It is subject to the license
# terms in the LICENSE.md file found in the top-level directory of
# this distribution and at https://github.com/pjones/effrb. No part of
# the effrb package, including this file, may be copied, modified,
# propagated, or distributed except according to the terms contained
# in the LICENSE.md file.

################################################################################
# <<: require
require('minitest/autorun')
# :>>

################################################################################
class MockingTest < MiniTest::Unit::TestCase

  ################################################################################
  module HTTP
    # <<: response
    class Response
      def success?
        # ...
      end

      def body
        # ...
      end
    end
    # :>>

    def self.get (url)
      Response.new
    end
  end


  ##############################################################################
  # <<: monitor
  require('uri')

  class Monitor
    def initialize (server)
      @server = server
    end

    def alive?
      echo = Time.now.to_f.to_s
      response = get(echo)
      response.success? && response.body == echo
    end

    private

    def get (echo)
      url = URI::HTTP.build(host: @server,
                            path: "/echo/#{echo}")

      HTTP.get(url.to_s)
    end
  end
  # :>>

  ##############################################################################
  def test_bare_monitor
    refute(Monitor.new("example.com").alive?)
  end

  ##############################################################################
  # <<: test_successful_monitor
  def test_successful_monitor
    monitor = Monitor.new("example.com")
    response = MiniTest::Mock.new

    monitor.define_singleton_method(:get) do |echo|
      response.expect(:success?, true)
      response.expect(:body, echo)
      response
    end

    assert(monitor.alive?, "should be alive")
    response.verify
  end
  # :>>

  ##############################################################################
  # <<: test_failed_monitor
  def test_failed_monitor
    monitor = Monitor.new("example.com")
    response = MiniTest::Mock.new

    monitor.define_singleton_method(:get) do |echo|
      response.expect(:success?, false)
      response
    end

    refute(monitor.alive?, "shouldn't be alive")
    response.verify
  end
  # :>>

  ##############################################################################
  # <<: test_bad_echo
  def test_bad_echo
    monitor = Monitor.new("example.com")
    response = MiniTest::Mock.new

    monitor.define_singleton_method(:get) do |echo|
      response.expect(:success?, true)
      response.expect(:body, echo + 'FAIL')
      response
    end

    refute(monitor.alive?, "shouldn't be alive")
    response.verify
  end
  # :>>
end
