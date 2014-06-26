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
# All the test file to work from this directory and the fake test dir.
begin
  dir = File.dirname(__FILE__)

  if dir.match(/test$/)
    require(File.expand_path('../../lib/oop.rb', dir))
  else
    require(File.expand_path('../lib/oop.rb', dir))
  end
end

################################################################################
# New module to keep from polluting Object with our Version class.
module Container

  ##############################################################################
  # Suck in the correct Version class.
  include(GoodVersion)

  ##############################################################################
  # <<: spec
  describe(Version) do
    describe("when parsing") do
      before do
        @version = Version.new("10.8.9")
      end

      it("creates three integers") do
        @version.major.must_equal(10)
        @version.minor.must_equal(8)
        @version.patch.must_equal(9)
      end
    end

    describe("when comparing") do
      before do
        @v1 = Version.new("2.1.1")
        @v2 = Version.new("2.3.0")
      end

      it("orders correctly") do
        @v1.wont_equal(@v2)
        @v1.must_be(:<, @v2)
      end
    end
  end
  # :>>
end
