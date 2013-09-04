# -*- autoconf -*-
#
# Copyright (C) 2013 Khaled Hosny and Barry Schwartz
# 
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# serial 1

# FIXME: Document these.

AC_DEFUN([StM_LIB_GIFLIB],[{ :
   AC_LIB_HAVE_LINKFLAGS([gif], [],
      [@%:@include <gif_lib.h>],
      [GifFileType f;
       int x = DGifCloseFile (&f);])
}])

AC_DEFUN([StM_LIB_GIFLIB_EXTENSION_BLOCK_FUNCTION],[{ :
   AC_CACHE_CHECK([for ExtensionBlock.Function in gif_lib.h],
   stm_cv_lib_giflib_extension_block_function,[
   AC_LINK_IFELSE([
      AC_LANG_PROGRAM([
@%:@include <stdio.h>
@%:@include <gif_lib.h>
         ],[
ExtensionBlock foo;
foo.Function=3;
         ])
      ],[
         stm_cv_lib_giflib_extension_block_function=yes
      ],[
         stm_cv_lib_giflib_extension_block_function=no
      ])
   ])
   AC_SUBST([HAVE_LIB_GIFLIB_EXTENSION_BLOCK_FUNCTION],
            ["${stm_cv_lib_giflib_extension_block_function}"])
}])

AC_DEFUN([StM_FUNC_DGIFOPENFILENAME_ERROR_RETURN],[{ :
   AC_CACHE_CHECK([whether DGifOpenFileName takes an error return parameter (giflib >= 5)],
      [stm_cv_func_dgifopenfilename_error_return],[
      AC_LINK_IFELSE([
         AC_LANG_PROGRAM([
@%:@include <stdio.h>
@%:@include <gif_lib.h>
         ],[
int error;
(void) DGifOpenFileName("filename", &error);
         ])
      ],[
         stm_cv_func_dgifopenfilename_error_return=yes
      ],[
         stm_cv_func_dgifopenfilename_error_return=no
      ])
   ])
   AC_SUBST([HAVE_DGIFOPENFILENAME_ERROR_RETURN],
            ["${stm_cv_func_dgifopenfilename_error_return}"])
   AC_DEFINE_UNQUOTED([HAVE_DGIFOPENFILENAME_ERROR_RETURN],
      [`(test "${stm_cv_func_dgifopenfilename_error_return}" = yes && echo 1) || echo 0`],
      [Define to 1 if DGifOpenFileName takes an error return parameter; otherwise define to 0.])
}])

dnl if test x"${i_do_have_giflib}" != xyes; then
dnl    FONTFORGE_WARN_PKG_NOT_FOUND([GIFLIB])
dnl    AC_DEFINE([_NO_LIBUNGIF],1,[Define if not using giflib or libungif.)])
dnl else
dnl    AC_CACHE_CHECK([whether DGifOpenFileName takes an error return parameter],
dnl      ac_cv_func_dgifopenfilename_error_return,
dnl      [AC_COMPILE_IFELSE([AC_LANG_PROGRAM([#include <stdio.h>
dnl #include <gif_lib.h>],[int error; (void) DGifOpenFileName("filename", &error);])],
dnl        [ac_cv_func_dgifopenfilename_error_return=yes],
dnl        [ac_cv_func_dgifopenfilename_error_return=no])])
dnl    D_GIF_OPEN_FILE_NAME_ERROR_RETURN=0
dnl    test x"${ac_cv_func_dgifopenfilename_error_return}" = xyes && D_GIF_OPEN_FILE_NAME_ERROR_RETURN=1
dnl    AC_DEFINE_UNQUOTED([D_GIF_OPEN_FILE_NAME_ERROR_RETURN],
dnl       [${D_GIF_OPEN_FILE_NAME_ERROR_RETURN}],
dnl       [Define as 1 if DGifOpenFileName takes an error return parameter (giflib 5); otherwise define as 0.])
dnl fi
dnl ])
