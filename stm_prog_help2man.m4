# -*- autoconf -*-
#
# Copyright (C) 2013 Khaled Hosny and Barry Schwartz
# 
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# serial 4

# StM_PROG_HELP2MAN
# -----------------
#
# Set HELP2MAN to the path of the first help2man in the PATH, or to an
# empty string if help2man is not found. The result is cached in
# ac_cv_path_HELP2MAN. The test may be overridden by setting HELP2MAN
# or the cache variable.
#
AC_DEFUN([StM_PROG_HELP2MAN],[
   AC_REQUIRE([AC_PROG_FGREP])
   StM_PATH_PROGS_CACHED_AND_PRECIOUS([HELP2MAN],[GNU help2man command],
      [help2man],[
         if LC_ALL=C LANG=C ${ac_path_HELP2MAN} --version 2>&1 | \
                 LC_ALL=C LANG=C ${FGREP} -q "Brendan O'Dea"; then
            ac_cv_path_HELP2MAN=${ac_path_HELP2MAN}
            ac_path_HELP2MAN_found=:
         fi
      ])
])
