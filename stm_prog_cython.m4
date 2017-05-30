# -*- autoconf -*-
#
# Copyright (C) 2017 Khaled Hosny and Barry Schwartz
# 
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# serial 1

# StM_PROG_CYTHON
# -------------
#
# Set CYTHON to the path of the first cython in the PATH, or to an empty
# string if cython is not found. The result is cached in
# ac_cv_path_CYTHON. The test may be overridden by setting CYTHON or the
# cache variable.
#
AC_DEFUN([StM_PROG_CYTHON],[{ :;
   AC_REQUIRE([AC_PROG_EGREP])
   StM_PATH_PROGS_CACHED_AND_PRECIOUS([CYTHON],[Cython translator command],
      [cython],[
         if LC_ALL=C LANG=C ${ac_path_CYTHON} --version 2>&1 | \
                 LC_ALL=C LANG=C ${EGREP} -i '^Cython version' 2> /dev/null > /dev/null; then
            ac_cv_path_CYTHON=${ac_path_CYTHON}
            ac_path_CYTHON_found=:
         fi
      ])
}])
