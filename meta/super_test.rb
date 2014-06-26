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
class SuperHookTest < MiniTest::Unit::TestCase

  ##############################################################################
  module WithoutSuper
    module Insert
      def inherited (subclass)
        @insert_called = true
      end

      def insert_called
        @insert_called ||= false # Silence warning
      end
    end

    # <<: d-base
    class DownloaderBase
      def self.inherited (subclass)
        handlers << subclass
      end

      def self.handlers
        @handlers ||= []
      end

      private_class_method(:handlers)
    end
    # :>>

    class DownloaderBase
      extend(Insert)
    end

    class DownloaderHTTP < DownloaderBase
    end
  end

  ##############################################################################
  module WithSuper
    class DownloaderBase
      extend(WithoutSuper::Insert)

      # <<: d-base-super
      def self.inherited (subclass)
        super
        handlers << subclass
      end
      # :>>

      def self.handlers
        @handlers ||= []
      end

      private_class_method(:handlers)
    end

    class DownloaderHTTP < DownloaderBase
    end
  end

  ##############################################################################
  def test_downloader
    assert([WithoutSuper::DownloaderHTTP], WithoutSuper::DownloaderBase.send(:handlers))
    assert([], WithoutSuper::DownloaderHTTP.send(:handlers))
    assert([WithSuper::DownloaderHTTP], WithSuper::DownloaderBase.send(:handlers))
    assert([], WithSuper::DownloaderHTTP.send(:handlers))

    assert(!WithoutSuper::DownloaderBase.insert_called)
    assert(WithSuper::DownloaderBase.insert_called)
  end
end
