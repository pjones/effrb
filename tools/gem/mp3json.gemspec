# -*- encoding: utf-8 -*-

################################################################################
# This file is part of the package effrb. It is subject to the license
# terms in the LICENSE.md file found in the top-level directory of
# this distribution and at https://github.com/pjones/effrb. No part of
# the effrb package, including this file, may be copied, modified,
# propagated, or distributed except according to the terms contained
# in the LICENSE.md file.

require File.expand_path('../lib/mp3json/version', __FILE__)

################################################################################
# This is a non-standard hack so I can include just the parts I want
# in the book examples.
def make_gemspec
  # <<: spec
  Gem::Specification.new do |gem|
    gem.add_dependency('id3tag', '0.7.0')
    gem.add_dependency('json',   '1.8.1')
    # ...
  end
  # :>>
end

make_gemspec.tap do |gem|
  gem.authors       = ["Peter J. Jones"]
  gem.email         = ["pjones@devalot.com"]
  gem.description   = %q{Wacky awesome way to turn ID3 tags into JSON!}
  gem.summary       = %q{Simple example of using Bundler}
  gem.homepage      = ""
  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "mp3json"
  gem.require_paths = ["lib"]
  gem.version       = Mp3json::VERSION
end
