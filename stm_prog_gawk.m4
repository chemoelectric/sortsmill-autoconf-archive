# -*- autoconf -*-
#
# Copyright (C) 2013 Khaled Hosny and Barry Schwartz
# 
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# serial 2

# StM_PROG_GAWK
# -------------
#
# Set GAWK to the path of the first gawk in the PATH, or to an empty
# string if gawk is not found. The result is cached in
# ac_cv_path_GAWK. The test may be overridden by setting GAWK or the
# cache variable.
#
AC_DEFUN([StM_PROG_GAWK],[
   AC_REQUIRE([AC_PROG_EGREP])
   StM_PATH_PROGS_CACHED_AND_PRECIOUS([GAWK],[GNU implementation of Awk],
      [gawk awk],[
         # Run a command that gawk, but neither mawk nor nawk, can execute.
         if LC_ALL=C LANG=C ${ac_path_GAWK} -- \
                 'BEGIN {s@<:@1@:>@="b"; s@<:@-2@:>@="a"; n=asorti(s,t); dnl
                         print s@<:@t@<:@1@:>@@:>@, s@<:@t@<:@2@:>@@:>@}' | \
                 LC_ALL=C LANG=C ${EGREP} -q '^a b$'; then
            ac_cv_path_GAWK=${ac_path_GAWK}
            ac_path_GAWK_found=:
         fi
      ])
])
