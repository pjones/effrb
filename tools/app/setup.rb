#!ruby -w

################################################################################
# This file is part of the package effrb. It is subject to the license
# terms in the LICENSE.md file found in the top-level directory of
# this distribution and at https://github.com/pjones/effrb. No part of
# the effrb package, including this file, may be copied, modified,
# propagated, or distributed except according to the terms contained
# in the LICENSE.md file.

################################################################################
# <<: require
require('bundler/setup')
Bundler.require
# :>>

################################################################################
require('./mp3.rb')

################################################################################
File.open(ARGV.first) do |file|
  mp3 = MP3.new(file)
  $stdout.puts(mp3.tags_as_json)
end
