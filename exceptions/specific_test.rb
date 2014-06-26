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
class SpecificTest < MiniTest::Unit::TestCase

  ##############################################################################
  class NetworkConnectionError < StandardError; end
  class InvalidRecordError < StandardError; end

  ##############################################################################
  def default_rescue
    logger = MiniTest::Mock.new
    logger.expect(:error, nil, [String])

    task = Object.new
    def task.perform; raise(RuntimeError); end

    # <<: default
    begin
      task.perform
    rescue => e
      logger.error("task failed: #{e}")
      # Swallow exception, abort task.
    end
    # :>>

    logger.verify
    return 1
  end

  ##############################################################################
  def blacklist
    logger = MiniTest::Mock.new
    logger.expect(:error, nil, [String])

    task = Object.new
    def task.perform; raise(RuntimeError); end

    # <<: blacklist
    begin
      task.perform
    rescue ArgumentError, LocalJumpError,
           NoMethodError, ZeroDivisionError
      # Don't actually handle these.
      raise
    rescue => e
      logger.error("task failed: #{e}")
      # Swallow exception, abort task.
    end
    # :>>

    logger.verify
    return 1
  end

  ##############################################################################
  def whitelist
    task = Object.new
    def task.perform; raise(NetworkConnectionError); end

    # <<: whitelist
    begin
      task.perform
    rescue NetworkConnectionError => e
      # Retry logic...
    rescue InvalidRecordError => e
      # Send record to support staff...
    end
    # :>>

    return 1
  end

  ##############################################################################
  def whitelist_wide
    service = MiniTest::Mock.new
    service.expect(:record, nil, [RuntimeError])

    task = Object.new
    def task.perform; raise(RuntimeError); end

    # <<: whitelist-wide
    begin
      task.perform
    rescue NetworkConnectionError => e
      # Retry logic...
    rescue InvalidRecordError => e
      # Send record to support staff...
    rescue => e
      service.record(e)
      raise
    ensure
      # ...
    end
    # :>>

  rescue
    service.verify
    return 1
  end

  ##############################################################################
  def generate_eof
    file = File.open("/dev/null")
    config = MiniTest::Mock.new
    config.expect(:parse_line, nil, [String])

    # <<: specific
    begin
      while line = file.readline
        config.parse_line(line)
      end
    rescue EOFError
      # Ignore EOF.
    end
    # :>>

    # config.verify: It won't actually be called.
    return 1
  end

  ##############################################################################
  def in_order
    # <<: order
    begin
      # ...
    rescue EOFError
      # ...
    rescue Exception => e
      logger.error("failure: #{e}")
      raise
    end
    # :>>

    return 1
  end

  ##############################################################################
  # <<: recover
  def send_to_support_staff (e)
    # ...
  rescue
    raise(e)
  end
  # :>>

  ##############################################################################
  def send_to_support_staff_wrapper
    raise(NetworkConnectionError)
  rescue NetworkConnectionError => e
    send_to_support_staff(e)
    return 1
  end

  ##############################################################################
  def test_a_lot_of_things
    assert_equal(1, default_rescue)
    assert_equal(1, generate_eof)
    assert_equal(1, in_order)
    assert_equal(1, blacklist)
    assert_equal(1, whitelist)
    assert_equal(1, whitelist_wide)
    assert_equal(1, send_to_support_staff_wrapper)
  end
end
