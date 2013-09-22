# -*- autoconf -*-
#
# Copyright (C) 2013 Khaled Hosny and Barry Schwartz
# 
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# serial 4

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

# StM_CONFIGMAKE_C_DEFINES
# ------------------------
#
# Defines GNU Make variables, `configmake_c_defines' and
# `configmake_c_defines_unquoted'.
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
# As a convenience, this macro calls StM_STANDARD_CONFIGMAKE_VARIABLES
# to set standard_configmake_variables.
#
AC_DEFUN([StM_CONFIGMAKE_C_DEFINES],[if true; then
   AC_REQUIRE([StM_STANDARD_CONFIGMAKE_VARIABLES])
   AC_SUBST([__configmake_cdef],
      ['expr "X\@%:@define $(strip $(1))$(shell echo $(strip $(2)) | LC_ALL=C tr \"@<:@a-z@:>@\" \"@<:@A-Z@:>@\")$(strip $(3)) \"$($(strip $(2)))\"" : "X\\(.*\\)"'])
   AC_SUBST([configmake_c_defines],
      ['if true; then $(foreach dirvar, $(2), $(call __configmake_cdef, $(1), $(dirvar), $(3));) fi'])
   AC_SUBST([__configmake_unquoted_cdef],
      ['expr "X\@%:@define $(strip $(1))$(shell echo $(strip $(2)) | LC_ALL=C tr \"@<:@a-z@:>@\" \"@<:@A-Z@:>@\")$(strip $(3)) $($(strip $(2)))" : "X\\(.*\\)"'])
   AC_SUBST([configmake_c_defines_unquoted],
      ['if true; then $(foreach dirvar, $(2), $(call __configmake_unquoted_cdef, $(1), $(dirvar), $(3));) fi'])
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
# to set standard_configmake_variables.
#
AC_DEFUN([StM_CONFIGMAKE_SCHEME_DEFINES],[if true; then
   AC_REQUIRE([StM_STANDARD_CONFIGMAKE_VARIABLES])
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
# to set standard_configmake_variables.
#
AC_DEFUN([StM_CONFIGMAKE_M4SUGAR_DEFINES],[if true; then
   AC_REQUIRE([StM_STANDARD_CONFIGMAKE_VARIABLES])
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
