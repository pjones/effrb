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
class ProcTest < MiniTest::Unit::TestCase

  ##############################################################################
  module NoArity

    # <<: noarity-stream
    class Stream
      def initialize (io=$stdin, chunk=64*1024)
        @io, @chunk = io, chunk
      end

      def stream (&block)
        loop do
          start = Time.now
          data = @io.read(@chunk)
          return if data.nil?

          time = (Time.now - start).to_f
          block.call(data, time)
        end
      end
    end
    # :>>

    # <<: file-size
    def file_size (file)
      File.open(file) do |f|
        bytes = 0

        s = Stream.new(f)
        s.stream {|data| bytes += data.size}

        bytes
      end
    end
    # :>>

    module_function(:file_size)
  end

  ##############################################################################
  def test_noarity_stream
    assert(!NoArity.file_size(__FILE__).zero?)
  end

  ##############################################################################
  module Arity
    class Stream
      def initialize (io=$stdin, chunk=64*1024)
        @io, @chunk = io, chunk
      end

      # <<: arity-stream
      def stream (&block)
        loop do
          start = Time.now
          data = @io.read(@chunk)
          return if data.nil?

          arg_count = block.arity
          arg_list = [data]

          if arg_count == 2 || ~arg_count == 2
            arg_list << (Time.now - start).to_f
          end

          block.call(*arg_list)
        end
      end
      # :>>
    end

    # <<: digest
    require('digest')

    def digest (file)
      File.open(file) do |f|
        sha = Digest::SHA256.new
        s = Stream.new(f)
        s.stream(&sha.method(:update))
        sha.hexdigest
      end
    end
    # :>>

    module_function(:digest)
  end

  ##############################################################################
  def test_with_arity
    assert(256, Arity.digest(__FILE__).length)
  end
end
