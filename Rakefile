################################################################################
# This file is part of the package effrb. It is subject to the license
# terms in the LICENSE.md file found in the top-level directory of
# this distribution and at https://github.com/pjones/effrb. No part of
# the effrb package, including this file, may be copied, modified,
# propagated, or distributed except according to the terms contained
# in the LICENSE.md file.

################################################################################
require('rake/testtask')

################################################################################
task(:default => [:test])

################################################################################
Rake::TestTask.new do |t|
  n,m,_ = RUBY_VERSION.split('.').map(&:to_i)

  files = Dir.glob("*/*_test.rb")
  files.reject! {|f| f.match(/2_0/)} unless n >= 2
  files.reject! {|f| f.match(/2_1/)} unless n > 2 || (n == 2 && m >= 1)

  t.test_files = files
  t.warning    = true
end
