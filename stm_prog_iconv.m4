# -*- autoconf -*-
#
# Copyright (C) 2013 Khaled Hosny and Barry Schwartz
# 
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# serial 1

# StM_PROG_ICONV
# --------------
#
# Set ICONV to the path of the first iconv in the PATH, or to an empty
# string if iconv is not found. The result is cached in
# ac_cv_path_ICONV. The test may be overridden by setting ICONV or the
# cache variable.
#
AC_DEFUN([StM_PROG_ICONV],[if true; then
   AC_REQUIRE([AC_PROG_FGREP])
   StM_PATH_PROGS_CACHED_AND_PRECIOUS([ICONV],[iconv command],
      [iconv],[
         # Check that iconv can convert between UTF-8, UTF-16BE,
         # UTF-16LE, UTF-32BE, or UTF-32LE, and the current codeset.
         if echo 'test string' \
                 | ${ac_path_ICONV} -t UTF-8    | ${ac_path_ICONV} -f UTF-8    \
                 | ${ac_path_ICONV} -t UTF-16LE | ${ac_path_ICONV} -f UTF-16LE \
                 | ${ac_path_ICONV} -t UTF-16BE | ${ac_path_ICONV} -f UTF-16BE \
                 | ${ac_path_ICONV} -t UTF-32LE | ${ac_path_ICONV} -f UTF-32LE \
                 | ${ac_path_ICONV} -t UTF-32BE | ${ac_path_ICONV} -f UTF-32BE \
                 | ${FGREP} 'test string' > /dev/null 2> /dev/null; then
            ac_cv_path_ICONV=${ac_path_ICONV}
            ac_path_ICONV_found=:
         fi
      ])
fi])
