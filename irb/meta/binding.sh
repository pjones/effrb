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
run_irb_replace_nil <<EOF
def glass_case_of_emotion
  x = "I'm in a " + __method__.to_s.tr('_', ' ')
  binding
end;nil
x = "I'm in scope";nil
eval("x")
eval("x", glass_case_of_emotion)
EOF
