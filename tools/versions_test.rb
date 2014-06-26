################################################################################
# This file is part of the package effrb. It is subject to the license
# terms in the LICENSE.md file found in the top-level directory of
# this distribution and at https://github.com/pjones/effrb. No part of
# the effrb package, including this file, may be copied, modified,
# propagated, or distributed except according to the terms contained
# in the LICENSE.md file.

################################################################################
require(File.expand_path('../lib/test.rb', File.dirname(__FILE__)))
require('bundler')

################################################################################
class VersionsTest < MiniTest::Unit::TestCase

  ##############################################################################
  def test_valid_gemfile
    (1..4).each do |n|
      d = load_gemfile("versions#{n}.gemfile")
      assert_kind_of(Bundler::Definition, d)
      assert_equal(1, d.current_dependencies.size)
    end
  end

  ##############################################################################
  def explicit_gemspec
    # <<: explicit_gemspec
    Gem::Specification.new do |gem|
      gem.add_dependency('money', '4.2.0')
      # ...
    end
    # :>>
  end

  ##############################################################################
  def test_explicit_gemspec
    spec = explicit_gemspec
    assert_equal(1, spec.dependencies.size)
  end

  ##############################################################################
  def range_gemspec
    # <<: range_gemspec
    Gem::Specification.new do |gem|
      gem.add_dependency('money', '>= 4.2.0', '< 5.2.0')
      # ...
    end
    # :>>
  end

  ##############################################################################
  def test_range_gemspec
    spec = range_gemspec
    assert_equal(1, spec.dependencies.size)
  end

  ##############################################################################
  private

  ##############################################################################
  def load_gemfile (name)
    gemfile = File.expand_path(name, File.dirname(__FILE__))
    lockfile = File.expand_path(name + ".lock", File.dirname(__FILE__))
    Bundler::Definition.build(gemfile, lockfile, [])
  end
end
