# -*- autoconf -*-
#
# Copyright (C) 2013 Khaled Hosny and Barry Schwartz
# 
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# serial 2

#################################
# Macros for working with PCRE  #
#################################

# StM_PCRE_CONFIG(variable)
# -------------------------
#
# Example use:
#
#    PKG_CHECK_MODULES([PCRE],[libpcre])
#    test -n "${PCRE_CFLAGS}" && CFLAGS="${PCRE_CFLAGS} ${CFLAGS}"
#    test -n "${PCRE_LIBS}" && LIBS="${PCRE_LIBS} ${LIBS}"
#
#    StM_PCRE_CONFIG([PCRE_CONFIG_JIT])
#    StM_PCRE_CONFIG([PCRE_CONFIG_JITTARGET])
#    StM_PCRE_CONFIG([PCRE_CONFIG__no_such_macro])
#
# Example results:
#
#    Cache variables:
#
#       stm_cv_lib_pcre_PCRE_CONFIG_JIT=1
#       stm_cv_lib_pcre_PCRE_CONFIG_JITTARGET='x86 64bit (little endian + unaligned)'
#       stm_cv_lib_pcre_PCRE_CONFIG__no_such_macro=''
#
#    AC_SUBST variables:
#
#       PCRE_CONFIG_JIT=1
#       PCRE_CONFIG_JITTARGET='x86 64bit (little endian + unaligned)'
#       PCRE_CONFIG__no_such_macro=''
#
#    AC_DEFINE macros (here written in C notation):
#
#       #define PCRE_CONFIG_JIT 1
#       #define PCRE_CONFIG_JITTARGET x86 64bit (little endian + unaligned)
#       /* #undef PCRE_CONFIG__no_such_macro */
#
AC_DEFUN([StM_PCRE_CONFIG],[{ :
   AC_CACHE_CHECK([the pcre_config value of $1],
      [stm_cv_lib_pcre_$1],
      [
         AC_LANG_PUSH([C])

         AC_LINK_IFELSE([
            AC_LANG_PROGRAM([
@%:@include <pcre.h>
@%:@include <stdio.h>
            ],[
int error;
int int_value;
unsigned long int ulong_value;
char *string_value;
int exit_status;

exit_status = 1;  /* pcre_config() returned error. */

switch ($1)
  {
@%:@ifdef PCRE_CONFIG_MATCH_LIMIT
  case PCRE_CONFIG_MATCH_LIMIT:
@%:@endif
@%:@ifdef PCRE_CONFIG_MATCH_LIMIT_RECURSION
  case PCRE_CONFIG_MATCH_LIMIT_RECURSION:
@%:@endif
  case -9999:
    error = pcre_config ($1, &ulong_value);
    if (error == 0)
      {
        printf ("%lu\n", ulong_value);
        exit_status = 0;
      }
    break;

@%:@ifdef PCRE_CONFIG_JITTARGET
  case PCRE_CONFIG_JITTARGET:
@%:@endif
  case -9998:
    error = pcre_config ($1, &string_value);
    if (error == 0)
      {
        if (string_value != NULL)
          printf ("%s\n", string_value);
        else
          printf ("(NULL)\n");
        exit_status = 0;
      }
    break;

@%:@ifdef PCRE_CONFIG_JIT
  case PCRE_CONFIG_JIT:
@%:@endif
@%:@ifdef PCRE_CONFIG_LINK_SIZE
  case PCRE_CONFIG_LINK_SIZE:
@%:@endif
@%:@ifdef PCRE_CONFIG_NEWLINE
  case PCRE_CONFIG_NEWLINE:
@%:@endif
@%:@ifdef PCRE_CONFIG_BSR
  case PCRE_CONFIG_BSR:
@%:@endif
@%:@ifdef PCRE_CONFIG_POSIX_MALLOC_THRESHOLD
  case PCRE_CONFIG_POSIX_MALLOC_THRESHOLD:
@%:@endif
@%:@ifdef PCRE_CONFIG_STACKRECURSE
  case PCRE_CONFIG_STACKRECURSE:
@%:@endif
@%:@ifdef PCRE_CONFIG_UTF16
  case PCRE_CONFIG_UTF16:
@%:@endif
@%:@ifdef PCRE_CONFIG_UTF32
  case PCRE_CONFIG_UTF32:
@%:@endif
@%:@ifdef PCRE_CONFIG_UTF8
  case PCRE_CONFIG_UTF8:
@%:@endif
@%:@ifdef PCRE_CONFIG_UNICODE_PROPERTIES
  case PCRE_CONFIG_UNICODE_PROPERTIES:
@%:@endif
  case -9997:
    error = pcre_config ($1, &int_value);
    if (error == 0)
      {
        printf ("%d\n", int_value);
        exit_status = 0;
      }
    break;

  default:
    exit_status = 2;  /* Unrecognized configuration parameter. */
    break;
  }
return exit_status;
            ])],
            [stm_cv_lib_pcre_$1=`./conftest${EXEEXT} || :`],
            [stm_cv_lib_pcre_$1=])

         AC_LANG_POP
      ])

   AC_SUBST([$1],["${stm_cv_lib_pcre_$1}"])
   test -n "${stm_cv_lib_pcre_$1}" &&
      AC_DEFINE_UNQUOTED([$1],[${stm_cv_lib_pcre_$1}],
         [Define to the pcre_config value of $1, if it is available.])
}])

# StM_FUNC_PCRE_FREE_STUDY
# ------------------------
#
# If libpcre does not have the `pcre_free_study' function, then the
# following AC_DEFINE is done (here written in C notation):
#
#    #define pcre_free_study pcre_free
#
# The cache variable stm_cv_func_pcre_free_study is set either to
# `yes' or to `no'.
AC_DEFUN([StM_FUNC_PCRE_FREE_STUDY],[{ :
   AC_CACHE_CHECK([for the pcre_free_study function],
      [stm_cv_func_pcre_free_study],[
         AC_LANG_PUSH([C])

         AC_LINK_IFELSE([
            AC_LANG_PROGRAM([
@%:@include <pcre.h>
            ],[
pcre_free_study (0);
            ])],
            [stm_cv_func_pcre_free_study=yes],
            [stm_cv_func_pcre_free_study=no]
         )

         AC_LANG_POP
   ])
   if test x"${stm_cv_func_pcre_free_study}" != xyes; then
      AC_DEFINE([pcre_free_study],[pcre_free],
         [Define to `pcre_free' if PCRE does not have the pcre_free_study function.])
   fi
}])
