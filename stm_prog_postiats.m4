# -*- autoconf -*-
#
# Copyright (C) 2015 Khaled Hosny and Barry Schwartz
# 
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# serial 1

# StM_PROG_PATSCC
# ---------------
#
# Set PATSCC to the path of the first Postiats (ATS2) version of atscc
# in the PATH, or to an empty string if no such command is found. The
# result is cached in stm_cv_path_PATSCC. The test may be overridden by
# setting PATSCC or the cache variable.
#
AC_DEFUN([StM_PROG_PATSCC],[{ :
   AC_REQUIRE([AC_PROG_EGREP])

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
}])


# StM_PATSCC_VERSION
# ------------------
#
AC_DEFUN([StM_PATSCC_VERSION],[{ :
   AC_PROG_AWK
   AC_REQUIRE([StM_PROG_PATSCC])

   AC_MSG_CHECKING([ATS/Postiats version])
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

   AC_ARG_VAR([PATSCC_VERSION],[ATS/Postiats version])
   AC_SUBST([PATSCC_MAJOR])
   AC_SUBST([PATSCC_MINOR])
   AC_SUBST([PATSCC_SUBMINOR])
}])