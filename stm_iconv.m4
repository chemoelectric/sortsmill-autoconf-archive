# -*- autoconf -*-
#
# Copyright (C) 2013 Khaled Hosny and Barry Schwartz
# 
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# serial 1

##################################
# Macros for working with iconv  #
##################################

# StM_ICONV_OPEN_CHECK_CONVERSION(encoding1, encoding2)
# -----------------------------------------------------
#
# Test if iconv_open(3) can open both ways for conversion between two
# encodings.
#
# Sets the cache variable
# stm_cv_func_iconv_open_<ENCODING1>_and_<ENCODING2> to `yes' or `no'.
#
# AC_DEFINEs HAVE_ICONV_OPEN_<ENCODING1>_AND_<ENCODING2> to `1' or `0'.
#
AC_DEFUN([StM_ICONV_OPEN_CHECK_CONVERSION],[{ :
   AC_LANG_PUSH([C])
   m4_pushdef([cachevar], AS_TR_SH([stm_cv_func_iconv_open_$1_and_$2]))                                               

   AC_CACHE_CHECK([whether iconv_open can open both ways for conversion between $1 and $2],
      cachevar,[
      AC_RUN_IFELSE([
         AC_LANG_PROGRAM([
@%:@       include <iconv.h>
         ],[
           return (iconv_open("$1", "$2") == (iconv_t) -1
                   || iconv_open("$2", "$1") == (iconv_t) -1) ? 1 : 0;
         ])
      ],
         eval cachevar=yes,
         eval cachevar=no
      )
   ])

   eval __stm_iconv_open_check_conversion__can_name=cachevar
   eval __stm_iconv_open_check_conversion__can=$`echo ${__stm_iconv_open_check_conversion__can_name}`
   if test "${__stm_iconv_open_check_conversion__can}" = yes; then
      __stm_iconv_open_check_conversion__n=1
   else
      __stm_iconv_open_check_conversion__n=0
   fi
   AC_DEFINE_UNQUOTED(AS_TR_CPP([HAVE_ICONV_OPEN_$1_AND_$2]),
      [${__stm_iconv_open_check_conversion__n}],
      [Define to 1 if iconv_open can open both ways for conversion between $1 and $2; otherwise define to 0.])
   AS_UNSET([__stm_iconv_open_check_conversion__can_name])
   AS_UNSET([__stm_iconv_open_check_conversion__can])
   AS_UNSET([__stm_iconv_open_check_conversion__n])

   m4_popdef([cachevar])
   AC_LANG_POP
}])

# StM_ICONV_OPEN_ENCODING_NAME(encoding, name1 name2 ..., [action_if_found], [action_if_not_found])
# -------------------------------------------------------------------------------------------------
#
# Check a list of encoding names to find one that seems to work.
#
# FIXME: Document this more fully.
#
# IMPORTANT NOTE: Default action on failure is to recommend GNU
# libiconv. Thus be careful to include at least one name that GNU
# libiconv will recognize, or else override the default action.
#
AC_DEFUN([StM_ICONV_OPEN_ENCODING_NAME],[{ :
   m4_pushdef([cachevar], AS_TR_SH([stm_cv_func_iconv_open_name_for_$1]))
   AC_LANG_PUSH([C])

   AC_CACHE_CHECK([for a name iconv_open recognizes for encoding $1],
      cachevar,[
      AC_LINK_IFELSE([
         AC_LANG_PROGRAM([
@%:@       include <stdio.h>
@%:@       include <iconv.h>
           const char *names[[]] = {
             m4_foreach_w(N, [$2], "N"[,])
             NULL
           };
         ],[
           char *n = NULL;
           int i = 0;
           while (n == NULL && names[[i]] != NULL)
             {
               if (iconv_open("ISO-8859-1", names[[i]]) != (iconv_t) -1
                   && iconv_open(names[[i]], "ISO-8859-1") != (iconv_t) -1)
                 n = names[[i]];
               i++;
             }
           if (n != NULL)
             printf ("%s", n);
           return (n == NULL) ? 1 : 0;
         ])
      ],[
         if ./conftest > /dev/null; then
            cachevar="`./conftest`"
         else
            cachevar='none found'
         fi
      ],[
         cachevar='none found'
      ])
   ])

   if test "${cachevar}" != 'none found'; then
      :
      m4_ifval([$3],[$3])
   else
      :
      m4_ifval([$4],[$4],
         [AC_MSG_ERROR([No name found for $1. Consider installing GNU libiconv.
           GNU libiconv homepage: <http://www.gnu.org/software/libiconv/>])])
   fi

   AC_DEFINE_UNQUOTED(AS_TR_CPP([ICONV_OPEN_NAME_FOR_$1]),
      ["${cachevar}"],
      [Define to a name iconv_open recognizes for encoding $1.])

   AC_LANG_POP
   m4_popdef([cachevar])
}])
