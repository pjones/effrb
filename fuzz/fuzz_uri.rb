################################################################################
# This file is part of the package effrb. It is subject to the license
# terms in the LICENSE.md file found in the top-level directory of
# this distribution and at https://github.com/pjones/effrb. No part of
# the effrb package, including this file, may be copied, modified,
# propagated, or distributed except according to the terms contained
# in the LICENSE.md file.

# <<: fuzz
require('fuzzbert')
require('uri')

fuzz('URI::HTTP::build') do
  data("random server names") do
    FuzzBert::Generators.random
  end

  deploy do |data|
    URI::HTTP.build(host: data, path: '/')
  end
end
# :>>
