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
run_irb_replace_nil -I$base/lib -rmeta.rb <<EOF | tail -n+4
include(AliasLogging)
Array.extend(LogMethod);nil
Array.log_method(:first); nil
[1, 2, 3].first
%w(a b c).first_without_logging
EOF
