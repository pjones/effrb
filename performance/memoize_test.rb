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
class MemoizeTest < MiniTest::Unit::TestCase

  ##############################################################################
  class CurrentUser
    User = Struct.new(:id) do
      def self.find (*); new; end
    end

    def initialize
      @current_user = nil
    end

    # <<: current_user
    def current_user
      @current_user ||= User.find(logged_in_user_id)
    end
    # :>>

    def current_user_long
      # <<: current_user_long
      @current_user || @current_user = User.find(logged_in_user_id)
      # :>>
    end

    def logged_in_user_id; 0; end
  end

  ##############################################################################
  def test_current_user
    c = CurrentUser.new
    assert(u = c.current_user)
    assert_equal(u.object_id, c.current_user.object_id)

    c = CurrentUser.new
    assert(u = c.current_user_long)
    assert_equal(u.object_id, c.current_user_long.object_id)
  end

  ##############################################################################
  class Shipping
    def initialize (files, parse)
      @files = files
      @parse = parse
    end

    # <<: shipped
    def shipped? (order_id)
      file = fetch_confirmation_file

      if file
        status = parse_confirmation_file(file)
        status[order_id] == :shipped
      end
    end
    # :>>

    def fetch_confirmation_file (*) @files.shift;  end
    def parse_confirmation_file (*) @parse; end
  end

  ##############################################################################
  class ShippingMemoize < Shipping
    # <<: shipped-memoize
    def shipped? (order_id)
      @status ||= begin
        file = fetch_confirmation_file
        file ? parse_confirmation_file(file) : {}
      end

      @status[order_id] == :shipped
    end
    # :>>
  end

  ##############################################################################
  def test_shipping
    files = [true, true, false]
    s = Shipping.new(files, {1 => :shipped})

    assert(s.shipped?(1))
    refute(s.shipped?(2))
    refute(s.shipped?(1))
    assert(files.empty?)
  end

  ##############################################################################
  def test_shipping_memoize
    files = [true, false]
    s = ShippingMemoize.new(files, {1 => :shipped})

    assert(s.shipped?(1))
    refute(s.shipped?(2))
    assert_equal(1, files.size)

    s = ShippingMemoize.new(files, nil)
    refute(s.shipped?(1))
    refute(s.shipped?(0))
    assert(files.empty?)
  end

  ##############################################################################
  class Expensive
    # <<: lookup
    def lookup (key)
      @cache ||= {} # Make sure @cache exists.

      @cache[key] ||= begin
        # ...
      end
    end
    # :>>
  end

  ##############################################################################
  def test_with_hash
    assert_nil(Expensive.new.lookup(9))
  end
end
