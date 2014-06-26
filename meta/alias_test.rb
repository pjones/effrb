################################################################################
# This file is part of the package effrb. It is subject to the license
# terms in the LICENSE.md file found in the top-level directory of
# this distribution and at https://github.com/pjones/effrb. No part of
# the effrb package, including this file, may be copied, modified,
# propagated, or distributed except according to the terms contained
# in the LICENSE.md file.

################################################################################
require(File.expand_path('../lib/test.rb', File.dirname(__FILE__)))
require(File.expand_path('../lib/meta.rb', File.dirname(__FILE__)))

################################################################################
class AliasTest < MiniTest::Unit::TestCase

  ##############################################################################
  class Foo
    extend(AliasLogging::LogMethod)

    def foo
      10
    end
  end

  ##############################################################################
  def test_log_method
    Foo.log_method(:foo)

    stdout, $stdout = $stdout, StringIO.new
    result = Foo.new.foo
    string, $stdout = $stdout.string, stdout
    assert_equal(10, result)
    assert(string.match(/calling method `foo'/))

    assert(Foo.public_instance_methods.include?(:foo_without_logging))
    Foo.unlog_method(:foo)
    assert(!Foo.public_instance_methods.include?(:foo_without_logging))
    assert_equal(10, Foo.new.foo)
  end

  ##############################################################################
  class Bar
    extend(AliasLogging::LogMethod)
    def bar_without_logging; end
    def bar; end
  end

  ##############################################################################
  def test_unique_check
    assert_raises(NameError) {Bar.log_method(:bar)}
  end
end
