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
class ResourcesTest < MiniTest::Unit::TestCase

  ##############################################################################
  class FileNaive
    def initialize (file_name)
      # <<: naive
      file = File.open(file_name, 'w')
      # ...
      file.close
      # :>>
    end
  end

  ##############################################################################
  def test_file_naive_is_created
    file_name = 'some_file.txt'
    assert(!File.exist?(file_name))
    FileNaive.new(file_name)
    assert(File.exist?(file_name))
    File.unlink(file_name)
  end

  ##############################################################################
  class FileBegin
    def initialize (file_name)
      # <<: begin
      begin
        file = File.open(file_name, 'w')
        # ...
      ensure
        file.close if file
      end
      # :>>
    end
  end

  ##############################################################################
  # This is starting to look familiar.
  def test_file_begin_is_created
    file_name = 'some_file.txt'
    assert(!File.exist?(file_name))
    FileBegin.new(file_name)
    assert(File.exist?(file_name))
    File.unlink(file_name)
  end

  ##############################################################################
  class FileBlock
    def initialize (file_name)
      # <<: block
      File.open(file_name, 'w') do |file|
        # ...
      end
      # :>>
    end
  end

  ##############################################################################
  # This is starting to look familiar.
  def test_file_block_is_created
    file_name = 'some_file.txt'
    assert(!File.exist?(file_name))
    FileBlock.new(file_name)
    assert(File.exist?(file_name))
    File.unlink(file_name)
  end

  ##############################################################################
  # <<: class
  class Lock
    def self.acquire
      lock = new  # Initialize the resource
      lock.exclusive_lock!
      yield(lock) # Give it to the block
    ensure
      # Make sure it gets unlocked.
      lock.unlock if lock
    end
  end
  # :>>

  ##############################################################################
  # Add a few more things.
  class Lock
    attr_reader(:unlocked)
    def unlock () @unlocked = true; end
    def exclusive_lock! () end
  end

  ##############################################################################
  # <<: use
  Lock.acquire do |lock|
    # Raising an exception here is okay.
  end
  # :>>

  ##############################################################################
  def test_yield_unlock_happy_path
    yielded = false

    resource = Lock.acquire do |r|
      yielded = true
      r
    end

    assert(yielded, "should have yielded")
    assert(resource.unlocked, "should have unlocked")
  end

  ##############################################################################
  def test_yield_unlock_exception
    checked = false
    resource = nil

    begin
      Lock.acquire do |r|
        resource = r
        raise("blow up!")
      end
    rescue
      checked = true
      assert(!resource.nil?)
      assert(resource.unlocked)
    end

    assert(checked)
  end

  ##############################################################################
  module OptionalYield

    ##############################################################################
    # <<: class
    class Lock
      def self.acquire
        lock = new # Initialize the resource.
        lock.exclusive_lock!

        if block_given?
          yield(lock)
        else
          lock # Act more like Lock.new.
        end
      ensure
        if block_given?
          # Make sure it gets unlocked.
          lock.unlock if lock
        end
      end
    end
    # :>>

    ##############################################################################
    # Add a few more things.
    class Lock
      attr_reader(:unlocked)
      def unlock () @unlocked = true; end
      def exclusive_lock! () end
    end

    ##############################################################################
    def self.use_lock_with_block
      # <<: use
      Lock.acquire do |resource|
        # Raising an exception here is okay.
      end
      # :>>
    end

    ############################################################################
    def self.use_lock_without_block
      # <<: new
      lock = Lock.acquire
      # Won't automatically unlock.
      # :>>
    end
  end

  ##############################################################################
  def test_returns_block_value
    yielded = OptionalYield::Lock.acquire {|r| 21}
    assert_equal(21, yielded)
  end

  ##############################################################################
  def test_acts_like_new
    lock = OptionalYield.use_lock_without_block
    assert(lock)
    assert(lock.unlocked.nil?)

    lock.unlock
    assert(lock.unlocked)
  end
end
