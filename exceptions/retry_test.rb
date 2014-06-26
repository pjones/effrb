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
class RetryTest < MiniTest::Unit::TestCase

  ##############################################################################
  class VendorDeadlockError < StandardError; end

  ##############################################################################
  # Fake sleep so the tests don't take forever.
  def sleep (sec)
    # Don't really sleep ;)
  end

  ##############################################################################
  def first_stab
    service = MiniTest::Mock.new
    service.expect(:update, nil, [nil])
    record = nil

    # <<: bad
    begin
      service.update(record)
    rescue VendorDeadlockError
      sleep(15)
      retry
    end
    # :>>

    service.verify
    return 1
  end

  ##############################################################################
  def rescue_loop
    service = MiniTest::Mock.new
    service.expect(:update, nil, [nil])
    record = nil

    # <<: while
    while true
      begin
        service.update(record)
      rescue VendorDeadlockError
        sleep(15)
        # Drop exception
      else
        break # Success, exit loop.
      end
    end
    # :>>

    service.verify
    return 1
  end

  ##############################################################################
  def bounded
    service = Object.new
    def service.update (x) raise(VendorDeadlockError); end
    record = nil

    # <<: bounded
    retries = 0

    begin
      service.update(record)
    rescue VendorDeadlockError
      raise if retries >= 3
      retries += 1
      sleep(15)
      retry
    end
    # :>>
  end

  ##############################################################################
  def backoff
    record = nil
    service = Object.new
    def service.update (x) raise(VendorDeadlockError); end

    logger = Object.new
    def logger.warn (x); end

    # <<: backoff
    retries = 0

    begin
      service.update(record)
    rescue VendorDeadlockError => e
      raise if retries >= 3
      retries += 1
      logger.warn("API failure: #{e}, retrying...")
      sleep(5 ** retries)
      retry
    end
    # :>>
  end

  ##############################################################################
  def test_a_bunch_of_stuff
    assert_equal(1, first_stab)
    assert_equal(1, rescue_loop)
    assert_raises(VendorDeadlockError) {bounded}
    assert_raises(VendorDeadlockError) {backoff}
  end
end
