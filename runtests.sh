#!/bin/sh

################################################################################
# This file is part of the package effrb. It is subject to the license
# terms in the LICENSE.md file found in the top-level directory of
# this distribution and at https://github.com/pjones/effrb. No part of
# the effrb package, including this file, may be copied, modified,
# propagated, or distributed except according to the terms contained
# in the LICENSE.md file.

base=`dirname $0`
RB_VERSIONS=`cat $base/ruby-versions.txt`
export PATH=$HOME/.rbenv/bin:$PATH

install () {
  if ! rbenv prefix $1 > /dev/null; then
      rbenv install $ver
  fi
}

run_test () {
  bundle install || exit 1
  bundle exec rake test || exit 1
  bundle exec fuzzbert --limit 2 fuzz/* || exit 1
  rm -f bug[0-9]*
}

for ver in $RB_VERSIONS; do
  install $ver

  export RBENV_VERSION=$ver
  eval "`rbenv init -`"

  if ! rbenv which bundle > /dev/null 2>&1; then
      gem install bundler
  fi

  rbenv rehash

  printf "====> RUBY_VERSION: "
  ruby -v

  OUT=`run_test 2>&1`
  [ $? -ne 0 ] && echo "$OUT" && exit 1
  echo "$OUT" | egrep '(warning|^[0-9]+ tests,)' | grep -v "unused variable"
done
