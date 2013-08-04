# -*- autoconf -*-
#
# Copyright (C) 2013 Khaled Hosny and Barry Schwartz
# 
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# serial 1

# FIXME: Document this macro.

AC_DEFUN([StM_PROG_PERL],[
   StM_PATH_PROGS_CACHED_AND_PRECIOUS([PERL],[Perl interpreter command],
      [perl],[
         if LC_ALL=C LANG=C ${ac_path_PERL} --version 2>&1 | \
                 LC_ALL=C LANG=C ${EGREP} -q -i '^This is perl'; then
            ac_cv_path_PERL=${ac_path_PERL}
            ac_path_PERL_found=:
         fi
      ])
])
