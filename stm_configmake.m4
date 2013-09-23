# -*- autoconf -*-
#
# Copyright (C) 2013 Khaled Hosny and Barry Schwartz
# 
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# serial 7

# StM_STANDARD_CONFIGMAKE_VARIABLES
# ---------------------------------
#
# Defines a GNU Make variable, standard_configmake_variables, that
# lists the same variables as are included (at the time of this
# writing) by Gnulib when it generates `configmake.h'.
#
AC_DEFUN([StM_STANDARD_CONFIGMAKE_VARIABLES], [if true; then
   AC_SUBST([standard_configmake_variables], 'm4_flatten([prefix
   exec_prefix bindir sbindir libexecdir datarootdir datadir
   sysconfdir sharedstatedir localstatedir includedir oldincludedir
   docdir infodir htmldir dvidir pdfdir psdir libdir lispdir localedir
   mandir pkgdatadir pkgincludedir pkglibdir pkglibexecdir])')
fi])

# StM_STANDARD_PKGINFO_VARIABLES
# ------------------------------
#
# Defines a GNU Make variable, standard_pkginfo_variables, that lists
# `standard' variables for the description of a Sorts Mill package.
#
AC_DEFUN([StM_STANDARD_PKGINFO_VARIABLES], [if true; then
   AC_SUBST([standard_pkginfo_variables], 'm4_flatten([
      PACKAGE PACKAGE_BUGREPORT PACKAGE_NAME PACKAGE_STRING
	  PACKAGE_TARNAME PACKAGE_URL PACKAGE_VERSION PACKAGE_VERSION_SHORT
	  VERSION_MAJOR VERSION_MINOR VERSION_PATCH VERSION_EXTRA
	  VERSION_EXTRA_SHORT])')
fi])

# StM_CONFIGMAKE_C_DEFINES
# ------------------------
#
# Defines GNU Make variables, `configmake_c_defines',
# `configmake_c_defines_unquoted', and `configmake_c_defines_utf8'.
#
# For example, calling
#
#    $(call configmake_c_defines, PREFIX_, bindir libdir PACKAGE, _SUFFIX)
#    $(call configmake_c_defines_unquoted, PREFIX_, numval1 NUMVAL2, _SUFFIX)
#
# results in shell code to send
#
#    #define PREFIX_BINDIR_SUFFIX "$(bindir)"
#    #define PREFIX_LIBDIR_SUFFIX "$(libdir)"
#    #define PREFIX_PACKAGE_SUFFIX "$(PACKAGE)"
#    #define PREFIX_NUMVAL1_SUFFIX $(numval1)
#    #define PREFIX_NUMVAL2_SUFFIX $(NUMVAL2)
#
# to standard output.
#
# You can leave out the third (`_SUFFIX') argument.
#
# If you call
#
#    $(call configmake_c_defines_utf8, PREFIX_, bindir libdir PACKAGE, _IN_UTF8)
#
# the result is code to `#define' PREFIX_BINDIR_IN_UTF8,
# PREFIX_LIBDIR_IN_UTF8, and PREFIX_PACKAGE_IN_UTF8, respectively, as
# initializers for uint8_t arrays; the data will represent a
# null-terminated UTF-8 string. For instance, if $(PACKAGE) is the
# string "ABC", one gets
#
#    #define PREFIX_PACKAGE_IN_UTF8 { 65, 66, 67, 0 }
#
# which can be used to initialize a uint8_t array.
#
# As a convenience, StM_CONFIGMAKE_C_DEFINES calls
# StM_STANDARD_CONFIGMAKE_VARIABLES and
# StM_STANDARD_PKGINFO_VARIABLES.
#
# FIXME: Would it make more sense to have `configmake_c_defines_utf8'
# produce strings of octal escapes, so the `#define'd macro could be
# used in more places? I do not know. The fine details of how C
# handles encodings in string literals is beyond my desire to research
# right now. Initializers such as the above have a clear meaning, and
# will work; furthermore, array of uint8_t is the respresentation for
# UTF-8 strings in libunistring.
#
AC_DEFUN([StM_CONFIGMAKE_C_DEFINES],[if true; then
   AC_REQUIRE([StM_STANDARD_CONFIGMAKE_VARIABLES])
   AC_REQUIRE([StM_STANDARD_PKGINFO_VARIABLES])
   AC_REQUIRE([AC_PROG_SED])
   AC_REQUIRE([StM_PROG_ICONV])
   if test -z "${ICONV}"; then
      AC_MSG_ERROR([An adequately working `iconv' command is required but was not found.
           Consider installing GNU libiconv.
           GNU libiconv homepage: <http://www.gnu.org/software/libiconv/>])
   fi
   AC_SUBST([__configmake_cdef],
      ['expr "X\@%:@define $(strip $(1))$(shell echo $(strip $(2)) | LC_ALL=C tr \"@<:@a-z@:>@\" \"@<:@A-Z@:>@\")$(strip $(3)) \"$($(strip $(2)))\"" : "X\\(.*\\)"'])
   AC_SUBST([configmake_c_defines],
      ['if true; then $(foreach dirvar, $(2), $(call __configmake_cdef, $(1), $(dirvar), $(3));) fi'])
   AC_SUBST([__configmake_unquoted_cdef],
      ['expr "X\@%:@define $(strip $(1))$(shell echo $(strip $(2)) | LC_ALL=C tr \"@<:@a-z@:>@\" \"@<:@A-Z@:>@\")$(strip $(3)) $($(strip $(2)))" : "X\\(.*\\)"'])
   AC_SUBST([configmake_c_defines_unquoted],
      ['if true; then $(foreach dirvar, $(2), $(call __configmake_unquoted_cdef, $(1), $(dirvar), $(3));) fi'])
  dnl
  dnl FIXME: The `\012' below assumes ASCII, as does the
  dnl        `s/[ 	]10[ 	]*$$//', and these will not work for EBCDIC.
  dnl        One doubts this will be a problem for Sorts Mill software,
  dnl        but it is worth knowing about.
  dnl
  dnl        See the discussion of `tr' at
  dnl        http://www.gnu.org/software/autoconf/manual/autoconf.html#Limitations-of-Usual-Tools
  dnl
  AC_SUBST([__configmake_utf8_cdef],
      ['expr "X\@%:@define $(strip $(1))$(shell echo $(strip $(2)) | LC_ALL=C tr \"@<:@a-z@:>@\" \"@<:@A-Z@:>@\")$(strip $(3)) `expr "X$($(strip $(2)))" : "X\\(.*\\)" | $(ICONV) -t UTF-8 | od -tu1 -An | tr "\\012" " " | $(SED) "s/[[ 	]]10[[ 	]]*$$//; s/\\([[0123456789]][[0123456789]]*\\)/\\1,/g; s/  */ /g; s/^/{/; s/$$/0 }/"`" : "X\\(.*\\)"'])
   AC_SUBST([configmake_c_defines_utf8],
      ['if true; then $(foreach dirvar, $(2), $(call __configmake_utf8_cdef, $(1), $(dirvar), $(3));) fi'])
fi])

# StM_CONFIGMAKE_SCHEME_DEFINES
# -----------------------------
#
# Defines GNU Make variables, `configmake_scheme_defines' and
# `configmake_scheme_defines_unquoted'.
#
# For example, calling
#
#    $(call configmake_scheme_defines, PREFIX_, bindir libdir PACKAGE, _SUFFIX)
#    $(call configmake_scheme_defines_unquoted, PREFIX_, numval1 NUMVAL2, _SUFFIX)
#
# results in shell code to send
#
#    (define PREFIX_BINDIR_SUFFIX "$(bindir)")
#    (define PREFIX_LIBDIR_SUFFIX "$(libdir)")
#    (define PREFIX_PACKAGE_SUFFIX "$(PACKAGE)")
#    (define PREFIX_NUMVAL1_SUFFIX $(numval1))
#    (define PREFIX_NUMVAL2_SUFFIX $(NUMVAL2))
#
# to standard output.
#
# You can leave out the third (`_SUFFIX') argument.
#
# As a convenience, this macro calls StM_STANDARD_CONFIGMAKE_VARIABLES
# and StM_STANDARD_PKGINFO_VARIABLES.
#
AC_DEFUN([StM_CONFIGMAKE_SCHEME_DEFINES],[if true; then
   AC_REQUIRE([StM_STANDARD_CONFIGMAKE_VARIABLES])
   AC_REQUIRE([StM_STANDARD_PKGINFO_VARIABLES])
   AC_SUBST([__configmake_schemedef],
      ['expr "X(define $(strip $(1))$(shell echo $(strip $(2)) | LC_ALL=C tr \"@<:@a-z@:>@\" \"@<:@A-Z@:>@\")$(strip $(3)) \"$($(strip $(2)))\")" : "X\\(.*\\)"'])
   AC_SUBST([configmake_scheme_defines],
      ['if true; then $(foreach dirvar, $(2), $(call __configmake_schemedef, $(1), $(dirvar), $(3));) fi'])
   AC_SUBST([__configmake_unquoted_schemedef],
      ['expr "X(define $(strip $(1))$(shell echo $(strip $(2)) | LC_ALL=C tr \"@<:@a-z@:>@\" \"@<:@A-Z@:>@\")$(strip $(3)) $($(strip $(2))))" : "X\\(.*\\)"'])
   AC_SUBST([configmake_scheme_defines_unquoted],
      ['if true; then $(foreach dirvar, $(2), $(call __configmake_unquoted_schemedef, $(1), $(dirvar), $(3));) fi'])
fi])

# StM_CONFIGMAKE_M4SUGAR_DEFINES
# ------------------------------
#
# Defines a GNU Make macro, `configmake_m4sugar_defines'.
#
# For example, calling
#
#    $(call configmake_m4sugar_defines, PREFIX_, bindir libdir PACKAGE, _SUFFIX)
#
# results in shell code to send
#
#    m4_define([PREFIX_BINDIR_SUFFIX],[$(bindir)])dnl
#    m4_define([PREFIX_LIBDIR_SUFFIX],[$(libdir)])dnl
#    m4_define([PREFIX_PACKAGE_SUFFIX],[$(PACKAGE)])dnl
#
# to standard output.
#
# You can leave out the third (`_SUFFIX') argument.
#
# As a convenience, this macro calls StM_STANDARD_CONFIGMAKE_VARIABLES
# and StM_STANDARD_PKGINFO_VARIABLES.
#
AC_DEFUN([StM_CONFIGMAKE_M4SUGAR_DEFINES],[if true; then
   AC_REQUIRE([StM_STANDARD_CONFIGMAKE_VARIABLES])
   AC_REQUIRE([StM_STANDARD_PKGINFO_VARIABLES])
   dnl  The occurrences of `""' are to stop Autoconf from
   dnl  complaining that `m4_define' and `dnl' appear in the output.
   AC_SUBST([__configmake_m4sugardef],
      ['expr "m""4_define(@<:@$(strip $(1))$(shell echo $(strip $(2)) | LC_ALL=C tr \"@<:@a-z@:>@\" \"@<:@A-Z@:>@\")$(strip $(3))@:>@,@<:@$($(strip $(2)))@:>@)d""nl" : "\\(.*\\)"'])
   AC_SUBST([configmake_m4sugar_defines],
      ['if true; then $(foreach dirvar, $(2), $(call __configmake_m4sugardef, $(1), $(dirvar), $(3));) fi'])
fi])

# StM_CONFIGMAKE_DEFINES
# ----------------------
#
# Combine all the above into one call.
#
AC_DEFUN([StM_CONFIGMAKE_DEFINES],[
   AC_REQUIRE([StM_CONFIGMAKE_C_DEFINES])
   AC_REQUIRE([StM_CONFIGMAKE_SCHEME_DEFINES])
   AC_REQUIRE([StM_CONFIGMAKE_M4SUGAR_DEFINES])
])
