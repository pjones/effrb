#!/bin/sh
# coding: utf-8

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
export RUBY_HIDE_HASH=':count=>9, :heap_length=>126, …'

################################################################################
run_irb_replace_nil <<EOF
GC.stat
EOF
