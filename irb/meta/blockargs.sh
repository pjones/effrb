#!/bin/sh

################################################################################
# This file is part of the package effrb. It is subject to the license
# terms in the LICENSE.md file found in the top-level directory of
# this distribution and at https://github.com/pjones/effrb. No part of
# the effrb package, including this file, may be copied, modified,
# propagated, or distributed except according to the terms contained
# in the LICENSE.md file.

################################################################################
. `dirname $0`/../common.sh

################################################################################
run_irb_replace_nil <<EOF | head -n-4
def test
  # Yield one argument.
  yield("a")
end;nil
test {|x, y, z| [x, y, z]} # Expect 3.
test {"b"} # Expect 0.
func = ->(x) {"Hello #{x}"} # Expect 1.
func.call("a", "b") # Send 2.
EOF
