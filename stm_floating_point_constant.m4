# -*- autoconf -*-
#
# Copyright (C) 2013 Khaled Hosny and Barry Schwartz
# 
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# serial 1

# StM_FLOATING_POINT_CONSTANT(expr, cache_var, format1, format2, [, action_on_failure] [, includes])
# --------------------------------------------------------------------------------------------------
#
# FIXME: Document this.
#
AC_DEFUN([StM_FLOATING_POINT_CONSTANT],[{ :
   AC_CACHE_CHECK([the value of $1],[$2],[

      AC_LANG_PUSH([C])
      __stm_floating_point_constant__save_libs="${LIBS}"
      LIBS="-lm ${LIBS}"

      AC_LINK_IFELSE([
         AC_LANG_PROGRAM([
#include <math.h>
#include <float.h>
#include <stdio.h>
#include <stdlib.h>
$6
            ],[
               int exp;
               double mant;
               mant = frexp (($1), &exp);
               if (mant == 0.5 && DBL_MIN_EXP < exp)
                 printf (($3), ($1), 1, 2, exp - 1);
               else
                 printf (($4), ($1), mant, 2, exp);
            ])
      ],[
         # Link succeeded.
         $2="`./conftest${EXEEXT}`"
      ],[
         # Link failed.
         :
      ])

      LIBS="${__stm_floating_point_constant__save_libs}"
      AC_LANG_POP
   ])

   if test -z "${$2}"; then
      m4_ifnblank([$5],[$5],[
         AC_MSG_FAILURE([Failed to find the value of $1])
      ])
   fi
}])

# StM_FLOAT_CONSTANT(expr, cache_var, [, action_on_failure] [, includes])
# -----------------------------------------------------------------------
#
# FIXME: Document this.
#
AC_DEFUN([StM_FLOAT_CONSTANT],[
   StM_FLOATING_POINT_CONSTANT([$1],[$2],
                               ["%.100g %d %d %d\n"],
                               ["%.100g %.100g %d %d\n"],
                               [$3],[$4])
])

# StM_DOUBLE_CONSTANT(expr, cache_var, [, action_on_failure] [, includes])
# ------------------------------------------------------------------------
#
# FIXME: Document this.
#
AC_DEFUN([StM_DOUBLE_CONSTANT],[
   StM_FLOATING_POINT_CONSTANT([$1],[$2],
                               ["%.100g %d %d %d\n"],
                               ["%.100lg %.100lg %d %d\n"],
                               [$3],[$4])
])

# StM_FLT_EPSILON
# ---------------
#
# FIXME: Document this.
#
AC_DEFUN([StM_FLT_EPSILON],[{ :
   AC_REQUIRE([AC_PROG_AWK])
   StM_FLOAT_CONSTANT([FLT_EPSILON],
                      [fontforge_cv_flconst_flt_epsilon])
   AC_SUBST([FLT_EPSILON],
      [`echo ${fontforge_cv_flconst_flt_epsilon} | ${AWK} '{ print @S|@1 }'`])
   AC_SUBST([FLT_EPSILON_FRACTION],
      [`echo ${fontforge_cv_flconst_flt_epsilon} | ${AWK} '{ print @S|@2 }'`])
   AC_SUBST([FLT_EPSILON_EXPONENT_BASE],
      [`echo ${fontforge_cv_flconst_flt_epsilon} | ${AWK} '{ print @S|@3 }'`])
   AC_SUBST([FLT_EPSILON_EXPONENT],
      [`echo ${fontforge_cv_flconst_flt_epsilon} | ${AWK} '{ print @S|@4 }'`])
}])

# StM_DBL_EPSILON
# ---------------
#
# FIXME: Document this.
#
AC_DEFUN([StM_DBL_EPSILON],[{ :
   AC_REQUIRE([AC_PROG_AWK])
   StM_DOUBLE_CONSTANT([DBL_EPSILON],
                       [fontforge_cv_flconst_dbl_epsilon])
   AC_SUBST([DBL_EPSILON],
      [`echo ${fontforge_cv_flconst_dbl_epsilon} | ${AWK} '{ print @S|@1 }'`])
   AC_SUBST([DBL_EPSILON_FRACTION],
      [`echo ${fontforge_cv_flconst_dbl_epsilon} | ${AWK} '{ print @S|@2 }'`])
   AC_SUBST([DBL_EPSILON_EXPONENT_BASE],
      [`echo ${fontforge_cv_flconst_dbl_epsilon} | ${AWK} '{ print @S|@3 }'`])
   AC_SUBST([DBL_EPSILON_EXPONENT],
      [`echo ${fontforge_cv_flconst_dbl_epsilon} | ${AWK} '{ print @S|@4 }'`])
}])
