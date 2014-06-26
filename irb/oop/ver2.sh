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
vs = %w(1.0.0  1.11.1  1.9.0).map {|v| Version.new(v)}
vs.sort
EOF
