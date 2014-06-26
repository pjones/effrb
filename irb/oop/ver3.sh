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
run_irb -I$base/lib -roop.rb <<EOF  | tail -n+4
include(GoodVersion)
a = Version.new('2.1.1')
b = Version.new('2.10.3')
[a > b, a >= b, a < b, a <= b, a == b]
Version.new('2.8.0').between?(a, b)
EOF
