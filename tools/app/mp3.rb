################################################################################
# This file is part of the package effrb. It is subject to the license
# terms in the LICENSE.md file found in the top-level directory of
# this distribution and at https://github.com/pjones/effrb. No part of
# the effrb package, including this file, may be copied, modified,
# propagated, or distributed except according to the terms contained
# in the LICENSE.md file.

class MP3
  def initialize (io)
    @tags = ID3Tag.read(io)
  end

  def tags_as_hash
    [:artist, :title, :album].reduce({}) do |hash, tag|
      hash[tag] = @tags.send(tag)
      hash
    end
  end

  def tags_as_json
    JSON.pretty_generate(tags_as_hash)
  end
end
