# -*- autoconf -*-
#
# Copyright (C) 2013 Khaled Hosny and Barry Schwartz
# 
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# serial 1

# StM_LIB_ZLIB
# ------------------
#
# Check for zlib.
#
# Users may set either or both of the precious variables ZLIB_CFLAGS
# and ZLIB_LIBS, or one can let the configure script try to set them.
#
AC_DEFUN([StM_LIB_ZLIB],[{ :
   AC_ARG_VAR([ZLIB_CFLAGS],[C compiler flags for zlib, overriding automatic detection])
   AC_ARG_VAR([ZLIB_LIBS],[linker flags for zlib, overriding automatic detection])

   StM_LIB_ZLIB__save_cflags="${CFLAGS}"
   StM_LIB_ZLIB__save_libs="${LIBS}"
   CFLAGS="${ZLIB_CFLAGS} ${CFLAGS}"
   LIBS="${ZLIB_LIBS} ${LIBS}"

   AC_CHECK_HEADERS([zlib.h])

   CFLAGS="${StM_LIB_ZLIB__save_cflags}"
   unset StM_LIB_ZLIB__save_cflags

   HAVE_ZLIB_H=0
   test x"${ac_cv_header_zlib_h}" = xyes && HAVE_ZLIB_H=1
   AC_SUBST([HAVE_ZLIB_H])
   AC_DEFINE_UNQUOTED([HAVE_ZLIB_H],[${HAVE_ZLIB_H}],
      [Define to 1 if we have the <zlib.h> header file, to 0 otherwise.])

   if test x"${ac_cv_header_zlib_h}" = xyes; then
      HAVE_ZLIB_LIB=1
      if test -z "${ZLIB_LIBS}"; then
         StM_LIB_ZLIB__save_libs="${LIBS}"
         LIBS=
         AC_SEARCH_LIBS([AO_locks],[zlib])
         ZLIB_LIBS="${LIBS}"
         test x"${ac_cv_search_AO_locks}" = xno && HAVE_ZLIB_LIB=0
         LIBS="${StM_LIB_ZLIB__save_libs}"
         unset StM_LIB_ZLIB__save_libs
      fi
   else
      # If we do not have the header, assume we do not have the
      # support library, because we cannot use it, anyway.
      HAVE_ZLIB_LIB=0

      # Ignore the precious variable settings.
      ZLIB_CFLAGS=
      ZLIB_LIBS=
   fi

   AC_SUBST([HAVE_ZLIB_LIB])
   AC_DEFINE_UNQUOTED([HAVE_ZLIB_LIB],[${HAVE_ZLIB_LIB}],
      [Define to 1 if we have the libz support library for <zlib.h>, to 0 otherwise.])
}])
