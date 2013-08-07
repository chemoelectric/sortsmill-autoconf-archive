# -*- autoconf -*-
#
# Copyright (C) 2013 Khaled Hosny and Barry Schwartz
# 
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# serial 4

# StM_PROG_SORTSMILL_CHANGELOGGER
# -------------------------------
#
# Set SORTSMILL_CHANGELOGGER to the path of the first
# sortsmill-changelogger in the PATH, or to an empty string if
# sortsmill-changelogger is not found. The result is cached in
# ac_cv_path_SORTSMILL_CHANGELOGGER. The test may be overridden by
# setting SORTSMILL_CHANGELOGGER or the cache variable.
#
AC_DEFUN([StM_PROG_SORTSMILL_CHANGELOGGER],[
   AC_REQUIRE([AC_PROG_FGREP])
   StM_PATH_PROGS_CACHED_AND_PRECIOUS([SORTSMILL_CHANGELOGGER],
      [Sorts Mill Changelogger command],
      [sortsmill-changelogger],
      [if LC_ALL=C LANG=C ${ac_path_SORTSMILL_CHANGELOGGER} -V 2>&1 | \
               LC_ALL=C LANG=C ${FGREP} -q -i 'Barry Schwartz'; then
          ac_cv_path_SORTSMILL_CHANGELOGGER="${ac_path_SORTSMILL_CHANGELOGGER}"
          ac_path_SORTSMILL_CHANGELOGGER_found=:
       fi])])
