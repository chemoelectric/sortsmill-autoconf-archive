#!/bin/sh
#
# You may run this to generate the `configure' script if it is not
# present or needs updating.

test -n "$srcdir" || srcdir=`dirname "$0"`
test -n "$srcdir" || srcdir=.

olddir=`pwd`
cd $srcdir

echo -n "checking for sortsmill-changeloggerize... "
which sortsmill-changeloggerize || {
	echo "*** No sortsmill-changeloggerize found.                    ***"
    echo "*** Please install sortsmill-changeloggerize,              ***"
    echo "*** which is part of the sortsmill-changelogger package:   ***"
    echo "*** https://bitbucket.org/sortsmill/sortsmill-changelogger ***"
	exit 1
}

echo -n "checking for autoreconf... "
which autoreconf || {
	echo "*** No autoreconf found, please install it ***"
	exit 1
}

echo "running sortsmill-changeloggerize -d config"
sortsmill-changeloggerize -d config || exit $?

echo "running autoreconf --install --verbose"
autoreconf --install --verbose || exit $?

cd $olddir
