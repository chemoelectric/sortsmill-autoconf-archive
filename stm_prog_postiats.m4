# -*- autoconf -*-
#
# Copyright (C) 2015 Khaled Hosny and Barry Schwartz
# 
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# serial 1

# StM_PROG_PATSCC([min-version])
# ------------------------------
#
# Set PATSCC to the path of the first Postiats (ATS2) version of atscc
# in the PATH, or to an empty string if no such command is found. The
# result is cached in ac_cv_path_PATSCC. The test may be overridden by
# setting PATSCC or the cache variable.
#
# If PATSCC is set, then also set PATSCC_VERSION, PATSCC_MAJOR,
# PATSCC_MINOR, and PATSCC_SUBMINOR. The PATSCC_VERSION variable is
# precious and may be overridden.
#
# FIXME: Document the optional `min-version' argument.
#
AC_DEFUN([StM_PROG_PATSCC],[{ :
   AC_REQUIRE([AC_PROG_EGREP])
   AC_REQUIRE([AC_PROG_AWK])

   StM_PATH_PROGS_CACHED_AND_PRECIOUS([PATSCC],
      [ATS/Postiats atscc command],
      [patscc atscc],[
         if LC_ALL=C LANG=C ${ac_path_PATSCC} -vats 2> /dev/null | \
                     LC_ALL=C LANG=C ${EGREP} 'ATS/Postiats version @<:@^@<:@:space:@:>@@:>@+' 2> /dev/null > /dev/null
         then
            ac_cv_path_PATSCC=${ac_path_PATSCC}
            ac_path_PATSCC_found=:
         fi
      ])

   AC_ARG_VAR([PATSCC_VERSION],[ATS/Postiats version])
   AC_SUBST([PATSCC_MAJOR])
   AC_SUBST([PATSCC_MINOR])
   AC_SUBST([PATSCC_SUBMINOR])

   if test -n "${ac_cv_path_PATSCC}"
   then
      AC_MSG_CHECKING([ATS/Postiats version])
      test -z "${PATSCC_VERSION}" &&
           PATSCC_VERSION=`LC_ALL=C LANG=C ${ac_path_PATSCC} -vats 2> /dev/null | LC_ALL=C LANG=C sed 's|^.*ATS/Postiats version \(@<:@0123456789@:>@@<:@0123456789.@:>@*\).*$|\1|'`
      AC_MSG_RESULT([${PATSCC_VERSION}])

      AC_MSG_CHECKING([ATS/Postiats major version])
      PATSCC_MAJOR=`echo ${PATSCC_VERSION} | ${AWK} -v FS=. '{print @S|@1}'`
      AC_MSG_RESULT([${PATSCC_MAJOR}])

      AC_MSG_CHECKING([ATS/Postiats minor version])
      PATSCC_MINOR=`echo ${PATSCC_VERSION} | ${AWK} -v FS=. '{print @S|@2}'`
      AC_MSG_RESULT([${PATSCC_MINOR}])

      AC_MSG_CHECKING([ATS/Postiats subminor version])
      PATSCC_SUBMINOR=`echo ${PATSCC_VERSION} | ${AWK} -v FS=. '{print @S|@3}'`
      AC_MSG_RESULT([${PATSCC_SUBMINOR}])
   fi

   if test -n "$1"
   then
      if test -n "${ac_cv_path_PATSCC}"
      then
         __i=1
         while true
         do
            __u=`echo $1 | ${AWK} -v FS=. '{print @S|@'"@S|@{__i}"'}'`
            __v=`echo ${PATSCC_VERSION} | ${AWK} -v FS=. '{print @S|@'"${__i}"'}'`
            test -z "${__u}" -a -z "${__v}" && break
            test -z "${__u}" && __u="0"
            test -z "${__v}" && __v="0"
            test "${__u}" -lt "${__v}" && break
            if test "${__v}" -lt "${__u}"
            then
               AC_MSG_WARN([Need ${ac_cv_path_PATSCC} version at least $1; got ${PATSCC_VERSION}.])
               AC_MSG_WARN([Assuming the ATS/Postiats compiler cannot be used.])
               unset PATSCC ac_cv_path_PATSCC
               unset PATSCC_VERSION PATSCC_MAJOR PATSCC_MINOR PATSCC_SUBMINOR
               break
            fi
            __i=`expr ${__i} + 1`
         done
         unset __i __u __v
      fi
   fi
}])
