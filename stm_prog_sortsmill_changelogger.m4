# -*- autoconf -*-
#
# Copyright (C) 2013 Khaled Hosny and Barry Schwartz
# 
# This file is free software; Khaled Hosny and Barry Schwartz give
# unlimited permission to copy and/or distribute it, with or without
# modifications, as long as this notice is preserved.

# serial 1

# FIXME: Document this macro.

AC_DEFUN([StM_PROG_SORTSMILL_CHANGELOGGER],[
   AC_PROG_FGREP
   StM_PATH_PROGS_CACHED_AND_PRECIOUS([SORTSMILL_CHANGELOGGER],
      [Sorts Mill Changelogger command],
      [sortsmill-changelogger],
      [if LC_ALL=C LANG=C ${ac_path_SORTSMILL_CHANGELOGGER} -V 2>&1 | \
               LC_ALL=C LANG=C ${FGREP} -q -i 'Barry Schwartz'; then
          ac_cv_path_SORTSMILL_CHANGELOGGER="${ac_path_SORTSMILL_CHANGELOGGER}"
          ac_path_SORTSMILL_CHANGELOGGER_found=:
       fi])])
