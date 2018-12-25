# -*- autoconf -*-
#
# Copyright (C) 2018 Barry Schwartz
# 
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# serial 1

# AC_CHECK_CONSTANT(expression, [includes = DEFAULT-INCLUDES], [if-fails])
# ------------------------------------------------------------------------
#
# Compute the value of the given constant expression. Cache the result
# in stm_cv_constant_<type-or-expr> variable, with ‘*’ mapped to ‘p’
# and other characters not suitable for a variable name mapped to
# underscores.
#
# If the computation fails: set stm_cv_constant_<type-or-expr> to
# zero, and run the ‘if-fails’ branch if it is present.
#
# This is a wrapper around AC_COMPUTE_INT, and thus will tend to work
# when cross-compiling.
#
AC_DEFUN([StM_CHECK_CONSTANT],
  [AS_LITERAL_IF(m4_translit([[$1]],[*],[p]),[],
                 [m4_fatal([$0: requires literal arguments])])]dnl
  [AC_CACHE_CHECK([value of $1],[AS_TR_SH([stm_cv_constant_$1])],
                  [AC_COMPUTE_INT([AS_TR_SH([stm_cv_constant_$1])],[$1],
                                  [AC_INCLUDES_DEFAULT([$2])],
                                  [AS_TR_SH([stm_cv_constant_$1])=0
                                   $3])])])
