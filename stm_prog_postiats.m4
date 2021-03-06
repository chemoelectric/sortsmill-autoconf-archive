# -*- autoconf -*-
#
# Copyright (C) 2015, 2018 Khaled Hosny and Barry Schwartz
# 
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# serial 3

# StM_PROG_PATSCC([min-version])
# ------------------------------
#
# Set PATSCC to the path of the first Postiats (ATS2) version of atscc
# in the PATH, or to an empty string if no such command is found. The
# result is cached in ac_cv_path_PATSCC. The test may be overridden by
# setting PATSCC or the cache variable.
#
# If PATSCC is set, then also set PATSCC_VERSION, PATSCC_MAJOR,
# PATSCC_MINOR, and PATSCC_SUBMINOR. The PATSCC_VERSION variable may
# be overridden.
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
         else
            unset ac_cv_path_PATSCC
         fi
      ])

   AC_SUBST([PATSCC_VERSION])
   AC_SUBST([PATSCC_MAJOR])
   AC_SUBST([PATSCC_MINOR])
   AC_SUBST([PATSCC_SUBMINOR])

   if test -n "${PATSCC}"
   then
      AC_MSG_CHECKING([ATS/Postiats patscc version])
      # Quietly allow PATSCC_VERSION to be overridden, just in case.
      test -z "${PATSCC_VERSION}" &&
            PATSCC_VERSION=`LC_ALL=C LANG=C ${PATSCC} -vats 2> /dev/null | LC_ALL=C LANG=C sed 's|^.*ATS/Postiats version \(@<:@0123456789@:>@@<:@0123456789.@:>@*\).*$|\1|'`
      AC_MSG_RESULT([${PATSCC_VERSION}])

      AC_MSG_CHECKING([ATS/Postiats patscc major version])
      PATSCC_MAJOR=`echo ${PATSCC_VERSION} | ${AWK} -v FS=. '{print @S|@1}'`
      AC_MSG_RESULT([${PATSCC_MAJOR}])

      AC_MSG_CHECKING([ATS/Postiats patscc minor version])
      PATSCC_MINOR=`echo ${PATSCC_VERSION} | ${AWK} -v FS=. '{print @S|@2}'`
      AC_MSG_RESULT([${PATSCC_MINOR}])

      AC_MSG_CHECKING([ATS/Postiats patscc subminor version])
      PATSCC_SUBMINOR=`echo ${PATSCC_VERSION} | ${AWK} -v FS=. '{print @S|@3}'`
      AC_MSG_RESULT([${PATSCC_SUBMINOR}])
   fi

   if test -n "$1"
   then
      if test -n "${PATSCC}"
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
               AC_MSG_WARN([Need ${PATSCC} version at least $1; got ${PATSCC_VERSION}.])
               AC_MSG_WARN([Assuming the ATS/Postiats compiler cannot be used.])
               unset PATSCC
               unset PATSCC_VERSION PATSCC_MAJOR PATSCC_MINOR PATSCC_SUBMINOR
               break
            fi
            __i=`expr ${__i} + 1`
         done
         unset __i __u __v
      fi
   fi
}])

# StM_PROG_PATSOPT([min-version])
# ------------------------------
#
# Set PATSOPT to the path of the first Postiats (ATS2) version of atsopt
# in the PATH, or to an empty string if no such command is found. The
# result is cached in ac_cv_path_PATSOPT. The test may be overridden by
# setting PATSOPT or the cache variable.
#
# If PATSOPT is set, then also set PATSOPT_VERSION, PATSOPT_MAJOR,
# PATSOPT_MINOR, and PATSOPT_SUBMINOR. The PATSOPT_VERSION variable may
# be overridden.
#
# FIXME: Document the optional `min-version' argument.
#
AC_DEFUN([StM_PROG_PATSOPT],[{ :
   AC_REQUIRE([AC_PROG_EGREP])
   AC_REQUIRE([AC_PROG_AWK])

   StM_PATH_PROGS_CACHED_AND_PRECIOUS([PATSOPT],
      [ATS/Postiats atsopt command],
      [patsopt atsopt],[
         if LC_ALL=C LANG=C ${ac_path_PATSOPT} -v 2> /dev/null | \
                     LC_ALL=C LANG=C ${EGREP} 'ATS/Postiats version @<:@^@<:@:space:@:>@@:>@+' 2> /dev/null > /dev/null
         then
            ac_cv_path_PATSOPT=${ac_path_PATSOPT}
            ac_path_PATSOPT_found=:
         else
            unset ac_cv_path_PATSOPT
         fi
      ])

   AC_SUBST([PATSOPT_VERSION])
   AC_SUBST([PATSOPT_MAJOR])
   AC_SUBST([PATSOPT_MINOR])
   AC_SUBST([PATSOPT_SUBMINOR])

   if test -n "${PATSOPT}"
   then
      AC_MSG_CHECKING([ATS/Postiats patsopt version])
      # Quietly allow PATSOPT_VERSION to be overridden, just in case.
      test -z "${PATSOPT_VERSION}" &&
            PATSOPT_VERSION=`LC_ALL=C LANG=C ${PATSOPT} -v 2> /dev/null | LC_ALL=C LANG=C sed 's|^.*ATS/Postiats version \(@<:@0123456789@:>@@<:@0123456789.@:>@*\).*$|\1|'`
      AC_MSG_RESULT([${PATSOPT_VERSION}])

      AC_MSG_CHECKING([ATS/Postiats patsopt major version])
      PATSOPT_MAJOR=`echo ${PATSOPT_VERSION} | ${AWK} -v FS=. '{print @S|@1}'`
      AC_MSG_RESULT([${PATSOPT_MAJOR}])

      AC_MSG_CHECKING([ATS/Postiats patsopt minor version])
      PATSOPT_MINOR=`echo ${PATSOPT_VERSION} | ${AWK} -v FS=. '{print @S|@2}'`
      AC_MSG_RESULT([${PATSOPT_MINOR}])

      AC_MSG_CHECKING([ATS/Postiats patsopt subminor version])
      PATSOPT_SUBMINOR=`echo ${PATSOPT_VERSION} | ${AWK} -v FS=. '{print @S|@3}'`
      AC_MSG_RESULT([${PATSOPT_SUBMINOR}])
   fi

   if test -n "$1"
   then
      if test -n "${PATSOPT}"
      then
         __i=1
         while true
         do
            __u=`echo $1 | ${AWK} -v FS=. '{print @S|@'"@S|@{__i}"'}'`
            __v=`echo ${PATSOPT_VERSION} | ${AWK} -v FS=. '{print @S|@'"${__i}"'}'`
            test -z "${__u}" -a -z "${__v}" && break
            test -z "${__u}" && __u="0"
            test -z "${__v}" && __v="0"
            test "${__u}" -lt "${__v}" && break
            if test "${__v}" -lt "${__u}"
            then
               AC_MSG_WARN([Need ${PATSOPT} version at least $1; got ${PATSOPT_VERSION}.])
               AC_MSG_WARN([Assuming the ATS/Postiats compiler cannot be used.])
               unset PATSOPT
               unset PATSOPT_VERSION PATSOPT_MAJOR PATSOPT_MINOR PATSOPT_SUBMINOR
               break
            fi
            __i=`expr ${__i} + 1`
         done
         unset __i __u __v
      fi
   fi
}])

# StM_PROG_POSTIATS([min-version])
# --------------------------------
#
# Run both StM_PROG_PATSCC and StM_PROG_PATOPT and check that atscc
# and atsopt are running the same version of the compiler. (Because
# atscc is a wrapper around atsopt, it is unlikely they will be
# mismatched, but it does not hurt to check.)
#
AC_DEFUN([StM_PROG_POSTIATS],[{ :
  StM_PROG_PATSCC([$1])
  StM_PROG_PATSOPT([$1])
  if test -z "${PATSCC}" -o -z "${PATSOPT}"
  then
    AC_MSG_WARN([Either ${PATSCC} or ${PATSOPT} is unavailable.])
    AC_MSG_WARN([Assuming the ATS/Postiats compiler cannot be used.])
    unset PATSCC PATSOPT
    unset PATSCC_VERSION PATSCC_MAJOR PATSCC_MINOR PATSCC_SUBMINOR
    unset PATSOPT_VERSION PATSOPT_MAJOR PATSOPT_MINOR PATSOPT_SUBMINOR
  elif test "${PATSCC_VERSION}" != "${PATSOPT_VERSION}"
  then
    AC_MSG_WARN([The versions of ${PATSCC} and ${PATSOPT} do not match.])
    AC_MSG_WARN([Assuming the ATS/Postiats compiler cannot be used.])
    unset PATSCC PATSOPT
    unset PATSCC_VERSION PATSCC_MAJOR PATSCC_MINOR PATSCC_SUBMINOR
    unset PATSOPT_VERSION PATSOPT_MAJOR PATSOPT_MINOR PATSOPT_SUBMINOR
  fi
}])

# StM_PROG_PATSOLVE_SMT2()
# ------------------------
#
# Set PATSOLVE_SMT2 to the path of the first version of patsolve_smt2
# in the PATH, or to an empty string if no such command is found. The
# result is cached in ac_cv_path_PATSOLVE_SMT2. The test may be
# overridden by setting PATSOLVE_SMT2 or the cache variable.
#
AC_DEFUN([StM_PROG_PATSOLVE_SMT2],[StM_PROG_POSTIATS_ACCESSORY__([PATSOLVE_SMT2],[patsolve_smt2])])

# StM_PROG_PATSOLVE_Z3()
# ----------------------
#
# Set PATSOLVE_Z3 to the path of the first version of patsolve_z3
# in the PATH, or to an empty string if no such command is found. The
# result is cached in ac_cv_path_PATSOLVE_Z3. The test may be
# overridden by setting PATSOLVE_Z3 or the cache variable.
#
AC_DEFUN([StM_PROG_PATSOLVE_Z3],[StM_PROG_POSTIATS_ACCESSORY__([PATSOLVE_Z3],[patsolve_z3])])


# StM_PROG_ATSCC2CLJ()
# --------------------
#
# Set ATSCC2CLJ to the path of the first version of atscc2clj
# in the PATH, or to an empty string if no such command is found. The
# result is cached in ac_cv_path_ATSCC2CLJ. The test may be
# overridden by setting ATSCC2CLJ or the cache variable.
#
AC_DEFUN([StM_PROG_ATSCC2CLJ],[StM_PROG_POSTIATS_ACCESSORY__([ATSCC2CLJ],[atscc2clj])])


# StM_PROG_ATSCC2JS()
# --------------------
#
# Set ATSCC2JS to the path of the first version of atscc2js
# in the PATH, or to an empty string if no such command is found. The
# result is cached in ac_cv_path_ATSCC2JS. The test may be
# overridden by setting ATSCC2JS or the cache variable.
#
AC_DEFUN([StM_PROG_ATSCC2JS],[StM_PROG_POSTIATS_ACCESSORY__([ATSCC2JS],[atscc2js])])

# StM_PROG_ATSCC2PHP()
# --------------------
#
# Set ATSCC2PHP to the path of the first version of atscc2php
# in the PATH, or to an empty string if no such command is found. The
# result is cached in ac_cv_path_ATSCC2PHP. The test may be
# overridden by setting ATSCC2PHP or the cache variable.
#
AC_DEFUN([StM_PROG_ATSCC2PHP],[StM_PROG_POSTIATS_ACCESSORY__([ATSCC2PHP],[atscc2php])])

# StM_PROG_ATSCC2PL()
# --------------------
#
# Set ATSCC2PL to the path of the first version of atscc2pl
# in the PATH, or to an empty string if no such command is found. The
# result is cached in ac_cv_path_ATSCC2PL. The test may be
# overridden by setting ATSCC2PL or the cache variable.
#
AC_DEFUN([StM_PROG_ATSCC2PL],[StM_PROG_POSTIATS_ACCESSORY__([ATSCC2PL],[atscc2pl])])

# StM_PROG_ATSCC2PY3()
# --------------------
#
# Set ATSCC2PY3 to the path of the first version of atscc2py3
# in the PATH, or to an empty string if no such command is found. The
# result is cached in ac_cv_path_ATSCC2PY3. The test may be
# overridden by setting ATSCC2PY3 or the cache variable.
#
AC_DEFUN([StM_PROG_ATSCC2PY3],[StM_PROG_POSTIATS_ACCESSORY__([ATSCC2PY3],[atscc2py3])])

# StM_PROG_ATSCC2R34()
# --------------------
#
# Set ATSCC2R34 to the path of the first version of atscc2r34
# in the PATH, or to an empty string if no such command is found. The
# result is cached in ac_cv_path_ATSCC2R34. The test may be
# overridden by setting ATSCC2R34 or the cache variable.
#
AC_DEFUN([StM_PROG_ATSCC2R34],[StM_PROG_POSTIATS_ACCESSORY__([ATSCC2R34],[atscc2r34])])

# StM_PROG_ATSCC2SCM()
# --------------------
#
# Set ATSCC2SCM to the path of the first version of atscc2scm
# in the PATH, or to an empty string if no such command is found. The
# result is cached in ac_cv_path_ATSCC2SCM. The test may be
# overridden by setting ATSCC2SCM or the cache variable.
#
AC_DEFUN([StM_PROG_ATSCC2SCM],[StM_PROG_POSTIATS_ACCESSORY__([ATSCC2SCM],[atscc2scm])])

# StM_PROG_POSTIATS_ACCESSORY__(xxx, yyy)
# ---------------------------------------
#
# A helper macro. (FIXME: Really document it.)
#
AC_DEFUN([StM_PROG_POSTIATS_ACCESSORY__],[{ :
   AC_REQUIRE([AC_PROG_FGREP])

   StM_PATH_PROGS_CACHED_AND_PRECIOUS([$1],
      [ATS/Postiats $2 command],
      [$2],[
         if LC_ALL=C LANG=C ${ac_path_$1} --help 2> /dev/null | \
                     LC_ALL=C LANG=C ${FGREP} 'Usage: $2 <command> ... <command>' 2> /dev/null > /dev/null
         then
            ac_cv_path_$1=${ac_path_$1}
            ac_path_$1_found=:
         else
            unset ac_cv_path_$1
         fi
      ])
}])
