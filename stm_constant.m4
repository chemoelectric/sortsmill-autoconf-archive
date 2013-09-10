# -*- autoconf -*-
#
# Copyright (C) 2013 Khaled Hosny and Barry Schwartz
# 
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# serial 1

# StM_CONSTANT(expr, cache_var, format, [, action_on_failure] [, includes])
# -------------------------------------------------------------------------
#
# FIXME: Document this.
#
AC_DEFUN([StM_CONSTANT],[{ :
   AC_CACHE_CHECK([the value of $1],[$2],[
      AC_LANG_PUSH([C])
      AC_LINK_IFELSE([
         AC_LANG_PROGRAM([
@%:@include <stdio.h>
$5
         ],[
            printf (($3), ($1));
         ])
      ],[
         # Link succeeded.
         $2="`./conftest${EXEEXT}`"
      ],[
         # Link failed.
         :
      ])
      AC_LANG_POP
   ])

   if test -z "${$2}"; then
      m4_ifnblank([$4],[$4],[
         AC_MSG_FAILURE([Failed to find the value of $1])
      ])
   fi
}])
