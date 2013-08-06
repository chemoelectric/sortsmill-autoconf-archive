# -*- autoconf -*-
#
# Copyright (C) 2013 Khaled Hosny and Barry Schwartz
# 
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# serial 1

# StM_COMPILER_FLAGS(variable, -flag1 -flag2 ...)
# -----------------------------------------------
#
# Repeated calls to GNU Autoconf Archive macro AX_CHECK_COMPILE_FLAG.
#
AC_DEFUN([StM_COMPILER_FLAGS],[
   m4_foreach_w([__flag],[$2],
                [AX_CHECK_COMPILE_FLAG(__flag,[$1="[$]{$1} __flag"])])
])
