# -*- autoconf -*-
#
# Copyright (C) 2013 Khaled Hosny and Barry Schwartz
# 
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# serial 1

# StM_LIB_TIFF
# ------------
#
# Check for libtiff. First (unless --with-libtiff-prefix is set) try
# PKG_CHECK_MODULES (from pkg.m4), then, if that fails, try
# AC_LIB_HAVE_LINKFLAGS (from Gnulib). Modify CPPFLAGS if appropriate,
# and AC_SUBST HAVE_LIBTIFF, LIBTIFF, and LTLIBTIFF.
#
AC_DEFUN([StM_LIB_TIFF],[{ :
   AC_SUBST([HAVE_LIBTIFF])
   AC_SUBST([LIBTIFF])
   AC_SUBST([LTLIBTIFF])

   if test "${with_libtiff_prefix+set}" = set; then
      __stm_lib_tiff__found_by_pkg=no
   else
      PKG_CHECK_MODULES([TIFF], [libtiff-4],
                        [__stm_lib_tiff__found_by_pkg=yes],
                        [__stm_lib_tiff__found_by_pkg=no])
   fi
   if test "${__stm_lib_tiff__found_by_pkg}" = yes; then
      HAVE_LIBTIFF=yes
      test -n "${TIFF_CFLAGS}" && CPPFLAGS="${CPPFLAGS} ${TIFF_CFLAGS}"
      LIBTIFF="${TIFF_LIBS}"
      LTLIBTIFF="${TIFF_LIBS}"
   else
      AC_LIB_HAVE_LINKFLAGS([tiff], [],
         [@%:@include <tiffio.h>],
         [TIFF *tif = TIFFOpen ("file.tif", "r");])
   fi

   AS_UNSET([__stm_lib_tiff__found_by_pkg])
   TIFF_CFLAGS='Do not program with this variable. It is for configure only.'
   TIFF_LIBS='Do not program with this variable. It is for configure only.'
}])
