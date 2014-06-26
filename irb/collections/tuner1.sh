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
run_irb -Isrc/lib -rcollections.rb <<EOF  | tail -n+4
include(MutateTuner)
presets = %w(90.1 106.2 88.5)
tuner = Tuner.new(presets)
presets
EOF
