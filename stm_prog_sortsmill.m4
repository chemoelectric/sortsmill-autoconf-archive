# -*- autoconf -*-
#
# Copyright (C) 2013 Khaled Hosny and Barry Schwartz
# 
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# serial 1

# StM_PROG_SORTSMILL
# ------------------
#
# Set SORTSMILL to the path of the first `sortsmill' in the PATH, or
# to an empty string if `sortsmill' is not found. The result is cached
# in ac_cv_path_SORTSMILL. The test may be overridden by setting
# SORTSMILL or the cache variable.
#
AC_DEFUN([StM_PROG_SORTSMILL],[if :; then
   AC_REQUIRE([AC_PROG_AWK])
   StM_PATH_PROGS_CACHED_AND_PRECIOUS([SORTSMILL],
      [sortsmill the program],
      [sortsmill],[
         if ${ac_path_SORTSMILL} --version | \
               ${AWK} 'NR==1 && /sortsmill \(Sorts Mill Tools\)/ { exit 0 }; { exit 1 }'; then
            ac_cv_path_SORTSMILL=${ac_path_SORTSMILL}
            ac_path_SORTSMILL_found=:
         fi
      ])
fi])
