# -*- autoconf -*-
#
# Copyright (C) 2018 Barry Schwartz
# 
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# serial 1

# StM_PROG_Z3
# -----------
#
# Set Z3 to the path of the first copy of the Z3 theorem prover in
# the PATH, or to an empty string if the program is not found. The
# result is cached in ac_cv_path_Z3. The test may be overridden by
# setting Z3 or the cache variable.
#
# FIXME: Support tests for different options such as input formats.
#
AC_DEFUN([StM_PROG_Z3],[{ :
   AC_REQUIRE([AC_PROG_EGREP])
   StM_PATH_PROGS_CACHED_AND_PRECIOUS([Z3],[Z3 theorem prover command],
      [z3],[         
         if LC_ALL=C LANG=C ${ac_path_Z3} -version | \
                 LC_ALL=C LANG=C ${EGREP} '^Z3 version ' 2> /dev/null > /dev/null; then
            ac_cv_path_Z3=${ac_path_Z3}
            ac_path_Z3_found=:
         fi
      ])
}])
