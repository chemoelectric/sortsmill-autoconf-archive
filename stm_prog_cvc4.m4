# -*- autoconf -*-
#
# Copyright (C) 2018 Barry Schwartz
# 
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# serial 1

# StM_PROG_CVC4
# -------------
#
# Set CVC4 to the path of the first copy of the CVC4 Theorem Prover in
# the PATH, or to an empty string if the program is not found. The
# result is cached in ac_cv_path_CVC4. The test may be overridden by
# setting CVC4 or the cache variable.
#
AC_DEFUN([StM_PROG_CVC4],[{ :
   AC_REQUIRE([AC_PROG_EGREP])
   StM_PATH_PROGS_CACHED_AND_PRECIOUS([CVC4],[CVC4 theorem prover command],
      [cvc4],[         
         if LC_ALL=C LANG=C ${ac_path_CVC4} --version | \
                 LC_ALL=C LANG=C ${EGREP} '^This is CVC4 version ' 2> /dev/null > /dev/null; then
            ac_cv_path_CVC4=${ac_path_CVC4}
            ac_path_CVC4_found=:
         fi
      ])
}])
