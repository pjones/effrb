################################################################################
# This file is part of the package effrb. It is subject to the license
# terms in the LICENSE.md file found in the top-level directory of
# this distribution and at https://github.com/pjones/effrb. No part of
# the effrb package, including this file, may be copied, modified,
# propagated, or distributed except according to the terms contained
# in the LICENSE.md file.
#!/usr/bin/env ruby -w

################################################################################
require(File.expand_path('../lib/test.rb', File.dirname(__FILE__)))
require(File.expand_path('../lib/meta.rb', File.dirname(__FILE__)))

################################################################################
class MethodMissingTest < MiniTest::Unit::TestCase

  ##############################################################################
  def test_raising_hash
    klasses = [ DelegationUsingMethodMissing::HashProxy,
                DelegationUsingDefineMethod::HashProxy,
              ]

    klasses.each do |klass|
      inst = klass.new
      inst[1] = 2
      assert_equal(2, inst[1])
      assert_equal(1, inst.size)
    end
  end


  ##############################################################################
  def test_audit_delegator
    klasses = [ DelegationUsingMethodMissing::AuditDecorator,
                DelegationUsingDefineMethod::AuditDecorator,
                DelegationUsingSingletonDefineMethod::AuditDecorator,
              ]

    klasses.each do |klass|
      object = []
      inst = klass.new(object)
      inst << "world"
      assert_equal(1, inst.size)
      assert_equal(1, object.size)

      inst << "hello"
      assert_equal("hello world", inst.sort.join(' '))
    end

    # Ensure transparency.
    single_audit = DelegationUsingSingletonDefineMethod::AuditDecorator.new([])
    assert_equal(Array, single_audit.class)
  end

  ##############################################################################
  def test_respond_missing
    h = DelegationRespondToMissing::HashProxy.new
    assert(h.respond_to?(:assoc))
    assert(h.method(:assoc))
    assert(!h.public_methods.include?(:assoc))
  end
end
