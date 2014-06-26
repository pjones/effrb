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
class ConstantsTest < MiniTest::Unit::TestCase

  ##############################################################################
  module Mutable
    # <<: mutable-defaults
    module Defaults
      NETWORKS = ["192.168.1", "192.168.2"]
    end
    # :>>

    module Functions
      def self.ping (*)
        false
      end

      # <<: purge_unreachable
      def purge_unreachable (networks=Defaults::NETWORKS)
        networks.delete_if do |net|
          !ping(net + ".1")
        end
      end
      # :>>

      module_function(:purge_unreachable)

      # <<: host_addresses
      def host_addresses (host, networks=Defaults::NETWORKS)
        networks.map {|net| net << ".#{host}"}
      end
      # :>>

      module_function(:host_addresses)
    end
  end

  ##############################################################################
  module FrozenA
    # <<: frozen-half
    module Defaults
      NETWORKS = ["192.168.1", "192.168.2"].freeze
    end
    # :>>
  end

  ##############################################################################
  module FrozenB
    # <<: frozen-all
    module Defaults
      NETWORKS = [
        "192.168.1",
        "192.168.2",
      ].map!(&:freeze).freeze
    end
    # :>>
  end

  ##############################################################################
  module FrozenC
    # <<: frozen-module
    module Defaults
      TIMEOUT = 5
    end

    Defaults.freeze
    # :>>
  end

  ##############################################################################
  def test_host_addresses
    before = Mutable::Defaults::NETWORKS.map {|n| n.dup}
    Mutable::Functions.host_addresses(1)
    refute_equal(before, Mutable::Defaults::NETWORKS)
    assert_equal(before.map {|n| n + ".1"}, Mutable::Defaults::NETWORKS)
  end

  ##############################################################################
  def test_purge
    before = Mutable::Defaults::NETWORKS.dup
    Mutable::Functions.purge_unreachable
    assert(Mutable::Defaults::NETWORKS.empty?)
    Mutable::Defaults::NETWORKS.concat(before)
  end

  ##############################################################################
  def test_freeze_works
    assert_raises(RuntimeError) {FrozenA::Defaults::NETWORKS.shift}
    assert_raises(RuntimeError) {FrozenB::Defaults::NETWORKS.shift}
    assert_raises(RuntimeError) {FrozenB::Defaults::NETWORKS.first << ".1"}

    assert_raises(RuntimeError) do
      # Work around a parse error in Ruby 1.9
      FrozenC::Defaults.module_eval("TIMEOUT=1")
    end
  end
end
