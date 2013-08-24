# -*- autoconf -*-
#
# Copyright (C) 2013 Khaled Hosny and Barry Schwartz
# 
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# serial 1

# StM_PROG_M4
# -----------
#
# Set M4 to the path of the first m4 in the PATH, or to an empty
# string if m4 is not found. The result is cached in
# ac_cv_path_M4. The test may be overridden by setting M4 or the cache
# variable.
#
# No checking that this is really an m4 is done, because running m4
# from inside another run of m4 is problematic. For the same reason,
# no special attempt is made to find GNU m4 instead of some other
# implementation.
#
AC_DEFUN([StM_PROG_M4],[{ :;
   StM_PATH_PROGS_CACHED_AND_PRECIOUS([M4],[m4 macro processor],
      [m4],
      [ac_cv_path_M4="${ac_path_M4}"
       ac_path_M4_found=:])
}])
