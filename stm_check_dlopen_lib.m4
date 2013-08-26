# -*- autoconf -*-
#
# Copyright (C) 2013 Khaled Hosny and Barry Schwartz
# 
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# serial 2

# StM_CHECK_DLOPEN_LIB(library, mode, [ldflags])
# ----------------------------------------------
#
# An explanatory example:
#
#    StM_CHECK_DLOPEN_LIB([libxine.so], [RTLD_LAZY | RTLD_GLOBAL], [-ldl])
#
# sets the cache variable
# stm_cv_dlopen_libxine_so_RTLD_LAZY_RTLD_GLOBAL to `yes' or `no',
# depending on whether a dlopen and dlclose of the library, with the
# given mode, succeeded.
#
# A full path can be used:
#
#    StM_CHECK_DLOPEN_LIB([/usr/lib/libxine.so], [RTLD_LAZY | RTLD_GLOBAL], [-ldl])
#
# sets the cache variable
# stm_cv_dlopen__usr_lib_libxine_so_RTLD_LAZY_RTLD_GLOBAL.
#
# If you know -ldl is in LIBS or is not needed then you can leave out
# the third argument:
#
#    StM_CHECK_DLOPEN_LIB([libxine.so], [RTLD_LAZY | RTLD_GLOBAL])
#
AC_DEFUN([StM_CHECK_DLOPEN_LIB],[{ :
   m4_ifnblank([$3],[
      __stm_check_dlopen_lib_saved_libs="${LIBS}"
      LIBS="$3 ${LIBS}"
   ])

   m4_pushdef([cachevar],[AS_TR_SH([stm_cv_dlopen_$1_[]m4_translit([$2],[
 	])])])

   AC_CACHE_CHECK([whether $1 can be dlopened in mode $2],[cachevar],[
      AC_LANG_PUSH([C])

      AC_RUN_IFELSE([
         AC_LANG_PROGRAM([
@%:@include <stdlib.h>
@%:@include <dlfcn.h>
         ],[
int error;
void *p;

p = dlopen ("$1", $2);
if (p == NULL)
 return 1; /* dlopen failed */
error = dlclose (p);
if (error != 0)
 return 2; /* dlclose failed */
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
      LIBS="${__stm_check_dlopen_lib_saved_libs}"
      unset __stm_check_dlopen_lib_saved_libs
   ])
}])
