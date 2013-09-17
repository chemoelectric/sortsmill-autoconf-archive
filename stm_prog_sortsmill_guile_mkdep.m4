# -*- autoconf -*-
#
# Copyright (C) 2013 Khaled Hosny and Barry Schwartz
# 
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# serial 1

# StM_PROG_SORTSMILL_GUILE_MKDEP
# ------------------------------
#
# Set SORTSMILL_GUILE_MKDEP to the path of the first
# sortsmill-guile-mkdep in the PATH, or to an empty string if
# sortsmill-guile-mkdep is not found. The result is cached in
# ac_cv_path_SORTSMILL_GUILE_MKDEP. The test may be overridden by
# setting SORTSMILL_GUILE_MKDEP or the cache variable.
#
# FIXME: Do a check on the --version option, once that is working.
# Until then, we just check that the program can be run.
#
AC_DEFUN([StM_PROG_SORTSMILL_GUILE_MKDEP],[{ :
#   AC_REQUIRE([AC_PROG_AWK])
   StM_PATH_PROGS_CACHED_AND_PRECIOUS([SORTSMILL_GUILE_MKDEP],
      [sortsmill-guile-mkdep the program],
      [sortsmill-guile-mkdep],[
#         if ${ac_path_SORTSMILL_GUILE_MKDEP} --version | \
#               ${AWK} 'NR==1 && /sortsmill-guile-mkdep \(Sorts Mill Core Guile\)/ { exit 0 }; { exit 1 }'; then
         if ${ac_path_SORTSMILL_GUILE_MKDEP}; then
            ac_cv_path_SORTSMILL_GUILE_MKDEP=${ac_path_SORTSMILL_GUILE_MKDEP}
            ac_path_SORTSMILL_GUILE_MKDEP_found=:
         fi
      ])
}])
