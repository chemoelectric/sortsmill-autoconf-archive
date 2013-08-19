# -*- autoconf -*-
#
# Copyright (C) 2013 Khaled Hosny and Barry Schwartz
# 
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# serial 1

# StM_BEGIN_END_OPTION(option_name, condition, [configure_args])
# --------------------------------------------------------------
#
# Example use:
#
#    StM_BEGIN_END_OPTION([enable_threads],
#                         [test x"${enable_threads}" = xyes],
#                         [--$1="${enable_threads}"])
#
# This defines AC_SUBST variables you can use to conditionally include
# C code (or C++ code, etc.):
#
#    [C code]
#       .
#       .
#       .
#    @BEGIN_enable_threads@
#       .
#       .
#       .
#    [C code that depends on threads support]
#       .
#       .
#       .
#    @END_enable_threads@
#       .
#       .
#       .
#    [C code]
#
AC_DEFUN([StM_BEGIN_END_OPTION],[
   if ( $2 ); then
      BEGIN_$1='#if 1 /* enabled by configure'
      END_$1='#endif /* enabled by configure'
   else
      BEGIN_$1='#if 0 /* disabled by configure'
      END_$1='#endif /* disabled by configure'
   fi
   m4_ifval([$3],[
      BEGIN_$1="${BEGIN_$1} $3"
      END_$1="${END_$1} $3"
   ])
   BEGIN_$1="${BEGIN_$1} */"
   END_$1="${END_$1} */"
   AC_SUBST([BEGIN_$1])
   AC_SUBST([END_$1])
   m4_ifdef([AM_SUBST_NOTMAKE],[
      dnl The definitions generally are harmless
      dnl but also are useless in Makefiles.
      AM_SUBST_NOTMAKE([BEGIN_$1])
      AM_SUBST_NOTMAKE([END_$1])
   ])
])
