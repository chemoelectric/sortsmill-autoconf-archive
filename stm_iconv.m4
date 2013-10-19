# -*- autoconf -*-
#
# Copyright (C) 2013 Khaled Hosny and Barry Schwartz
# 
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# This implementation includes code adapted from absolute-header.m4 of
# Gnulib, and thus:

# Copyright (C) 2006-2013 Free Software Foundation, Inc.
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# serial 4

##################################
# Macros for working with iconv  #
##################################

# StM_ICONV_OPEN_CHECK_CONVERSION(encoding1, encoding2, [target_suffix])
# --------------------------------------------------------------------
#
# Test if iconv_open(3) can open both ways for conversion between two
# encodings.
#
# Sets the cache variable
# stm_cv_func_iconv_open_<ENCODING1>_and_<ENCODING2> or
# stm_cv_func_iconv_open_<ENCODING1>_and_<ENCODING2>_with_<TARGET_SUFFIX>
# to `yes' or `no'
#
# AC_DEFINEs HAVE_ICONV_OPEN_<ENCODING1>_AND_<ENCODING2> or
# HAVE_ICONV_OPEN_<ENCODING1>_AND_<ENCODING2>_with_<TARGET_SUFFIX> to
# `1' or `0'.
#
AC_DEFUN([StM_ICONV_OPEN_CHECK_CONVERSION],[
if :
then
   AC_LANG_PUSH([C])
   m4_pushdef([cachevar],
      m4_ifnblank([$3],
         AS_TR_SH([stm_cv_func_iconv_open_$1_and_$2_with_$3]),
         AS_TR_SH([stm_cv_func_iconv_open_$1_and_$2])))

   AC_CACHE_CHECK(
      m4_ifnblank([$3],
         [whether iconv_open can open for $1 and $2 with target suffix $3],
         [whether iconv_open can open for $1 and $2]),
      cachevar,[
      AC_RUN_IFELSE([
         AC_LANG_PROGRAM([
@%:@        include <iconv.h>
         ],[
            return (iconv_open("$1$3", "$2") == (iconv_t) -1
                    || iconv_open("$2$3", "$1") == (iconv_t) -1) ? 1 : 0;
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
      m4_ifnblank([$3],
         [Define to 1 if iconv_open can open for $1 and $2 with target suffix; otherwise define to 0.],
         [Define to 1 if iconv_open can open for $1 and $2; otherwise define to 0.]))
   AS_UNSET([__stm_iconv_open_check_conversion__can_name])
   AS_UNSET([__stm_iconv_open_check_conversion__can])
   AS_UNSET([__stm_iconv_open_check_conversion__n])

   m4_popdef([cachevar])
   AC_LANG_POP
fi])

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
AC_DEFUN([StM_ICONV_OPEN_ENCODING_NAME],[
if :
then
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
fi])

# StM_CHECK_ICONV_IS_GNU
# ----------------------
#
# If the iconv implementation seems to be GNU, without expensive
# testing, then set the cache variable stm_cv_iconv_is_gnu to `yes';
# otherwise set the variable to `no'.
#
AC_DEFUN([StM_CHECK_ICONV_IS_GNU], [
if :
then
   AC_REQUIRE([AC_PROG_AWK])
   AC_CHECK_HEADER([iconv.h])
   AC_CACHE_CHECK([whether iconv is GNU], [stm_cv_iconv_is_gnu], [
      stm_cv_iconv_is_gnu=no
      if test x"${ac_cv_header_iconv_h}" = xyes; then
         _stm__gl_ABSOLUTE_HEADER_ONE([iconv.h])

         # Examine near the top of the header to see if it belongs
         # to glibc or GNU libiconv. If it does, then we conclude
         # iconv is GNU. Hopefully this is reliable.
         ${AWK} 'BEGIN {status=1} \
                 NR <= 5 && tolower(@S|@0) ~ /this file is part of .*(gnu c library|gnu libiconv)/ {status=0} \
                 END {exit status}' "${stmgl_cv_absolute_iconv_h}" && stm_cv_iconv_is_gnu=yes
      fi
   ])
fi])

# _stm__gl_ABSOLUTE_HEADER_ONE(HEADER)
# ------------------------------------
#
# Adapted from absolute-header.m4, serial 16, which is part of Gnulib.
#
# Like gl_ABSOLUTE_HEADER, except that:
#   - it assumes that the header exists,
#   - it uses the current CPPFLAGS,
#   - it does not cache the result,
#   - it is silent.
#
AC_DEFUN([_stm__gl_ABSOLUTE_HEADER_ONE],
[
  AC_REQUIRE([AC_PROG_CPP])
  AC_REQUIRE([AC_CANONICAL_HOST])
  AC_LANG_CONFTEST([AC_LANG_SOURCE([[#include <]]m4_dquote([$1])[[>]])])
  dnl AIX "xlc -E" and "cc -E" omit #line directives for header files
  dnl that contain only a #include of other header files and no
  dnl non-comment tokens of their own. This leads to a failure to
  dnl detect the absolute name of <dirent.h>, <signal.h>, <poll.h>
  dnl and others. The workaround is to force preservation of comments
  dnl through option -C. This ensures all necessary #line directives
  dnl are present. GCC supports option -C as well.
  case "$host_os" in
    aix*) stmgl_absname_cpp="${CPP} -C" ;;
    *)    stmgl_absname_cpp="${CPP}" ;;
  esac
changequote(,)
  case "$host_os" in
    mingw*)
      dnl For the sake of native Windows compilers (excluding gcc),
      dnl treat backslash as a directory separator, like /.
      dnl Actually, these compilers use a double-backslash as
      dnl directory separator, inside the
      dnl   # line "filename"
      dnl directives.
      stmgl_dirsep_regex='[/\\]'
      ;;
    *)
      stmgl_dirsep_regex='\/'
      ;;
  esac
  dnl A sed expression that turns a string into a basic regular
  dnl expression, for use within "/.../".
  stmgl_make_literal_regex_sed='s,[]$^\\.*/[],\\&,g'
  stmgl_header_literal_regex=`echo '$1' \
                           | sed -e "$stmgl_make_literal_regex_sed"`
  stmgl_absolute_header_sed="/${stmgl_dirsep_regex}${stmgl_header_literal_regex}/"'{
      s/.*"\(.*'"${stmgl_dirsep_regex}${stmgl_header_literal_regex}"'\)".*/\1/
      s|^/[^/]|//&|
      p
      q
    }'
changequote([,])
  dnl eval is necessary to expand stmgl_absname_cpp.
  dnl Ultrix and Pyramid sh refuse to redirect output of eval,
  dnl so use subshell.
  AS_VAR_SET([stmgl_cv_absolute_]AS_TR_SH([[$1]]),
[`(eval "$stmgl_absname_cpp conftest.$ac_ext") 2>&AS_MESSAGE_LOG_FD |
  sed -n "$stmgl_absolute_header_sed"`])
])
