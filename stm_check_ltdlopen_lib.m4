# -*- autoconf -*-
#
# Copyright (C) 2013 Khaled Hosny and Barry Schwartz
# 
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# serial 1

###############################
# Checks for use with libltdl #
###############################

m4_define([__stm_check_ltdlopen_lib],[
   m4_ifnblank([$3],[
      __stm_check_ltdlopen_lib_saved_libs="${LIBS}"
      LIBS="$3 ${LIBS}"
   ])

   m4_pushdef([cachevar],[AS_TR_SH([stm_cv_ltdlopen$1_$2])])

   AC_CACHE_CHECK([whether $2 can be loaded with lt_dlopen$1],[cachevar],[
      AC_LANG_PUSH([C])

      AC_RUN_IFELSE([
         AC_LANG_PROGRAM([
@%:@include <stdlib.h>
@%:@include <ltdl.h>
         ],[
int error;
lt_dlhandle h;

error = lt_dlinit ();
if (error != 0)
  return 8; /* lt_dlinit failed */

h = lt_dlopen$1 ("$2");
if (h == NULL)
  return 1; /* lt_dlopenext failed */

error = lt_dlclose (h);
if (error != 0)
 return 2; /* lt_dlclose failed */

error = lt_dlexit ();
if (error != 0)
  return 9; /* lt_dlexit failed */
         ])
      ],[
         eval cachevar=yes
      ],[
         eval cachevar=no
      ])

      AC_LANG_POP
   ])

   m4_popdef([cachevar])

   m4_ifnblank([$3],[
      LIBS="${__stm_check_ltdlopen_lib_saved_libs}"
      unset __stm_check_ltdlopen_lib_saved_libs
   ])
])

# StM_CHECK_LTDLOPEN_LIB(library, [ldflags])
# ---------------------------------------------
#
# An explanatory example:
#
#    StM_CHECK_LTDLOPEN_LIB([libxine.so], [-lltdl])
#
# sets the cache variable stm_cv_ltdlopen_libxine_so to `yes' or `no',
# depending on whether lt_dlopen and lt_dlclose succeed for
# `libxine.so'.
#
# A full path can be used:
#
#    StM_CHECK_LTDLOPEN_LIB([/usr/lib/libxine.so], [-lltdl])
#
# sets the cache variable stm_cv_ltdlopen__usr_lib_libxine_so.
#
# If you know -lltdl is in LIBS then you can leave out the second
# argument:
#
#    StM_CHECK_LTDLOPEN_LIB([libxine])
#
AC_DEFUN([StM_CHECK_LTDLOPEN_LIB],[{ :
  __stm_check_ltdlopen_lib([], [$1]m4_ifnblank([$2],[, $2]))
}])

# StM_CHECK_LTDLOPENEXT_LIB(library, [ldflags])
# ---------------------------------------------
#
# An explanatory example:
#
#    StM_CHECK_LTDLOPENEXT_LIB([libxine], [-lltdl])
#
# sets the cache variable stm_cv_ltdlopenext_libxine to `yes' or `no',
# depending on whether lt_dlopen and lt_dlclose succeed for `libxine'.
#
# A full path can be used:
#
#    StM_CHECK_LTDLOPENEXT_LIB([/usr/lib/libxine.so], [-lltdl])
#
# sets the cache variable stm_cv_ltdlopenext__usr_lib_libxine_so.
#
# If you know -lltdl is in LIBS then you can leave out the second
# argument:
#
#    StM_CHECK_LTDLOPENEXT_LIB([libxine])
#
AC_DEFUN([StM_CHECK_LTDLOPENEXT_LIB],[{ :
  __stm_check_ltdlopen_lib([ext], [$1]m4_ifnblank([$2],[, $2]))
}])
