#!/bin/sh
#
# You may run this to generate the `configure' script if it is not
# present or needs updating.

test -n "$srcdir" || srcdir=`dirname "$0"`
test -n "$srcdir" || srcdir=.

olddir=`pwd`
cd $srcdir

echo -n "checking for autoreconf... "
which autoreconf || {
	echo "*** No autoreconf found, please install it ***"
	exit 1
}

echo "running autoreconf --install --verbose"
autoreconf --install --verbose || exit $?

cd $olddir
