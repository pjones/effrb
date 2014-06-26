#!/bin/sh

################################################################################
# This file is part of the package effrb. It is subject to the license
# terms in the LICENSE.md file found in the top-level directory of
# this distribution and at https://github.com/pjones/effrb. No part of
# the effrb package, including this file, may be copied, modified,
# propagated, or distributed except according to the terms contained
# in the LICENSE.md file.

################################################################################
base=`dirname $0`/../..

if which readlink 2>&1 > /dev/null; then
  base=`readlink -f $base`
fi

################################################################################
# Load rbenv
export PATH=$HOME/.rbenv/bin:$PATH
export RBENV_VERSION=`head -1 $base/ruby-versions.txt`
eval "`rbenv init -`"

################################################################################
run_irb () {
  irb -f --noreadline --inspect -I$base/irb -rirbrc.rb $@ 2>&1 \
    | sed -e '1d' -e '$d' # Damn IRB includes 2 extra lines!
}

################################################################################
run_irb_replace_nil () {
  run_irb $@ | sed 's/;[ ]*nil//g' | grep -v -- '---> nil'
}

################################################################################
remove_irb_warn () {
  sed 's/(irb):[0-9]*: //'
}
