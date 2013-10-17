# -*- mode: makefile-gmake; coding: utf-8 -*-
#
# serial 4
#
m4_define([_StM_LIBRARY_MK_COPYRIGHT],
[# -*- mode: makefile-gmake; coding: utf-8 -*-
#
# Copyright (C) 2013 Khaled Hosny and Barry Schwartz
# 
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.])

AC_DEFUN([StM_LIBRARY_MK], [if :; then
AC_REQUIRE([AC_PROG_MKDIR_P])
AC_REQUIRE([AC_PROG_SED])
AC_REQUIRE([StM_PROG_ICONV])
m4_changecom()
AC_CONFIG_COMMANDS([library.mk],
[cat > library.mk <<_____StM_EOF_EOF_EOF_EOF_EOF_EOF_____
AS_ESCAPE([_StM_LIBRARY_MK_COPYRIGHT

#--------------------------------------------------------------------------
#
# A library of GNU Make macros.
#
#--------------------------------------------------------------------------

# $(call split-path, a:b:c:d) → a b c d
split-path = $(strip $(subst :, ,$(1)))

# $(call find-in-dirlist, file, a b c /d/e) returns the first of
# a/file, b/file, c/file, /d/e/file that it finds by searching the
# directory list, or else returns an empty string.
find-in-dirlist = $(if $(strip $(2)),$(if $(realpath $(firstword $(2))/$(strip $(1))),$(2)/$(strip $(1)),$(call find-in-dirlist,$(1),$(wordlist 2,$(words $(2)),$(2)))))

# $(call find-in-path, file, a:b:c:/d/e) returns the first of
# a/file, b/file, c/file, /d/e/file that it finds by searching the
# directory list, or else returns an empty string.
find-in-path = $(call find-in-dirlist,$(1),$(call split-path,$(2)))

# $(call find, file, a:b:c:/d/e) returns ‘file’ if the file
# exists, else it searches for the file in the VPATH, using
# find-in-path.
find = $(if $(realpath $(1)),$(1),$(call find-in-path,$(1),$(VPATH)))

# $(call filter-one-dir, dir, file1 file2 ...)  finds pathnames that
# fall within only a particular directory, but not within a
# subdirectory of it. (This is not quite the actual behavior, because
# symbolic links _are not_ resolved.)
filter-one-dir = \
	$(addprefix $(strip $(1))/, $(strip \
		$(shell printf '%s\n' '$(subst $(abspath $(strip $(1)))/, ,$(filter $(abspath $(strip $(1)))/%,$(abspath $(2))))' \
				| $(or $(SED),sed) 's%@<:@^ 	@:>@@<:@^ 	@:>@*/@<:@^ 	@:>@*%%g')))

#--------------------------------------------------------------------------

# $(call take, 2, a b c d e) → a b
take = $(wordlist 1, $(1), $(2))

# $(call drop, 2, a b c d e) → c d e
drop = $(wordlist $(shell expr $(1) + 1), $(words $(2)), $(2))

# $(call apply-in-bunches, macro, 2, a b c d e) → $(call macro, a b)$(call macro, c d)$(call macro, e)
apply-in-bunches = $(if $(strip $(call take, $(2), $(3))), \
	$(call $(1), $(call take, $(2), $(3)))$(call apply-in-bunches, $(1), $(2), $(call drop, $(2), $(3))))

# $(call remove, a b c) will remove the files a, b, and c.
#
# $(call apply-in-bunches, remove, 25, $(files)) will remove files in
# bunches of 25.
remove = rm -f $(1);

#--------------------------------------------------------------------------

# Propagate phony targets to submakes.
#
# Examples:
#
#    $(eval $(call propagate-phony, clean, lib))
#
# creates a phony target ‘clean-in-lib’ that is a prerequisite of
# ‘clean’, with a recipe that runs ‘$(MAKE) -C lib clean’.
#
#    $(eval $(call propagate-phony, clean, lib, $$(MAKE) $$(AM_MAKEFLAGS)))
#
# would run ‘$(MAKE) $(AM_MAKEFLAGS) -C lib clean’ instead.
#
define propagate-phony =
# The parent phony depends on the child.
$(strip $(1)): $(strip $(1))-in-$(strip $(2))
#
# The child itself is phony.
.PHONY: $(strip $(1))-in-$(strip $(2))
#
# The child is the same as the parent, but in a subdirectory.
$(strip $(1))-in-$(strip $(2)):
	$(or $(4),$$(MAKE)) -C $(2) $(1)
endef

#--------------------------------------------------------------------------

# Silent rules commands.
#
# Examples:
#
#    generated-file: prereq
#       $(call v, GEN) generate $< -o $@
#
#    foo.o: foo.c
#       $(call v, CC) cc -c foo.c
#
# DEFAULT_VERBOSITY (or, if that is not set, AM_DEFAULT_VERBOSITY)
# should be set to 0, if you want rules to be ‘silent’ by default.
#
# Setting V=0 or V=1 on the command line works as with silent rules in
# Automake.
#
v = $(if $(filter 0,$(or $(V),$(if $(filter-out $(flavor DEFAULT_VERBOSITY),undefined),$(DEFAULT_VERBOSITY),$(AM_DEFAULT_VERBOSITY)))),@printf "  %-8s %s\n" $(1) $(@);)

#--------------------------------------------------------------------------
#
# Generation of ‘configmake’-like files.

# The same variables as are included (at the time of this writing) by
# Gnulib when it generates ‘configmake.h’.
standard-configmake-variables = prefix exec_prefix bindir sbindir	\
	libexecdir datarootdir datadir sysconfdir sharedstatedir		\
	localstatedir includedir oldincludedir docdir infodir htmldir	\
	dvidir pdfdir psdir libdir lispdir localedir mandir pkgdatadir	\
	pkgincludedir pkglibdir pkglibexecdir

# ‘Standard’ variables for the description of a Sorts Mill package.
standard-pkginfo-variables = PACKAGE PACKAGE_BUGREPORT PACKAGE_NAME	\
	PACKAGE_STRING PACKAGE_TARNAME PACKAGE_URL PACKAGE_VERSION		\
	PACKAGE_VERSION_SHORT VERSION_MAJOR VERSION_MINOR VERSION_PATCH	\
	VERSION_EXTRA VERSION_EXTRA_SHORT

# Generation of C headers.
#
# For example, calling
#
#    $(call configmake-c-defines, PREFIX_, bindir libdir PACKAGE, _SUFFIX)
#    $(call configmake-c-defines-unquoted, PREFIX_, numval1 NUMVAL2, _SUFFIX)
#
# results in shell code to send
#
#    #define PREFIX_BINDIR_SUFFIX "$(bindir)"
#    #define PREFIX_LIBDIR_SUFFIX "$(libdir)"
#    #define PREFIX_PACKAGE_SUFFIX "$(PACKAGE)"
#    #define PREFIX_NUMVAL1_SUFFIX $(numval1)
#    #define PREFIX_NUMVAL2_SUFFIX $(NUMVAL2)
#
# to standard output, except embedded double-quotes are
# escaped. (For now, embedded newlines are not handled.)
#
# You can leave out the third (`_SUFFIX') argument.
#
# If you call
#
#    $(call configmake-c-defines-utf8, PREFIX_, bindir libdir PACKAGE, _IN_UTF8)
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
# configmake-c-defines-utf8 requires iconv.
#
configmake-c-defines = if :; then $(foreach dirvar, $(2), $(call __configmake_cdef, $(1), $(dirvar), $(3));) fi
__configmake_cdef = printf "\#define %s \"%s\"\n" "$(strip $(1))$(shell echo $(strip $(2)) | LC_ALL=C tr '@<:@a-z@:>@' '@<:@A-Z@:>@')$(strip $(3))" "$(subst ",\\\",$($(strip $(2))))"
#"
configmake-c-defines-unquoted = if :; then $(foreach dirvar, $(2), $(call __configmake_unquoted_cdef, $(1), $(dirvar), $(3));) fi
__configmake_unquoted_cdef = printf "\#define %s %s\n" "$(strip $(1))$(shell echo $(strip $(2)) | LC_ALL=C tr '@<:@a-z@:>@' '@<:@A-Z@:>@')$(strip $(3))" "$(subst ",\",$($(strip $(2))))"
#"
# The $(addprefix ,...) below evens out the spacing. It is like
# $(shell echo ...) but without the limitations of whatever echo is
# being used.
configmake-c-defines-utf8 = if :; then $(foreach dirvar, $(2), $(call __configmake_utf8_cdef, $(1), $(dirvar), $(3));) fi
__configmake_utf8_cdef = printf "\#define %s { %s 0 }\n" "$(strip $(1))$(shell echo $(strip $(2)) | LC_ALL=C tr '@<:@a-z@:>@' '@<:@A-Z@:>@')$(strip $(3))" "$(addprefix , $(shell printf "%s" "$(subst ",\",$($(strip $(2))))" | $(or $(ICONV),iconv) -t UTF-8 | od -tu1 -An | $(or $(SED),sed) 's/\(@<:@0123456789@:>@@<:@0123456789@:>@*\)/\1,/g'))"
#"

# Generation of Scheme sources.
#
# For example, calling
#
#    $(call configmake-scheme-defines, PREFIX_, bindir libdir PACKAGE, _SUFFIX)
#    $(call configmake-scheme-defines-unquoted, PREFIX_, numval1 NUMVAL2, _SUFFIX)
#
# results in shell code to send
#
#    (define PREFIX_BINDIR_SUFFIX "$(bindir)")
#    (define PREFIX_LIBDIR_SUFFIX "$(libdir)")
#    (define PREFIX_PACKAGE_SUFFIX "$(PACKAGE)")
#    (define PREFIX_NUMVAL1_SUFFIX $(numval1))
#    (define PREFIX_NUMVAL2_SUFFIX $(NUMVAL2))
#
# to standard output, except that the quoted strings actually are
# translated to UTF-8 encoding, and embedded double-quotes are
# escaped. (Guile 2.0 respects Emacs-style `-*-coding:utf-8;-*-' and
# similar notations near the tops of source files.)
#
# You can leave out the third (`_SUFFIX') argument.
#
# Requires iconv.
#
configmake-scheme-defines = if :; then $(foreach dirvar, $(2), $(call __configmake_schemedef, $(1), $(dirvar), $(3));) fi
__configmake_schemedef = printf "(define %s \"%s\")\n" "$(strip $(1))$(shell echo $(strip $(2)) | LC_ALL=C tr '@<:@a-z@:>@' '@<:@A-Z@:>@')$(strip $(3))" "$(shell printf "%s" "$(subst ",\\\",$($(strip $(2))))" | $(or $(ICONV),iconv) -t UTF-8)"
#"
configmake-scheme-defines-unquoted = if :; then $(foreach dirvar, $(2), $(call __configmake_unquoted_schemedef, $(1), $(dirvar), $(3));) fi
__configmake_unquoted_schemedef = printf "(define %s %s)\n" "$(strip $(1))$(shell echo $(strip $(2)) | LC_ALL=C tr '@<:@a-z@:>@' '@<:@A-Z@:>@')$(strip $(3))" "$(subst ",\",$($(strip $(2))))"
#"

# Generation of M4sugar sources.
#
# For example, calling
#
#    $(call configmake-m4sugar-defines, PREFIX_, bindir libdir PACKAGE, _SUFFIX)
#
# results in shell code to send
#
#    m4_ifndef([__M4_DEFINE__],[m4_define([__M4_DEFINE__],m4_defn([m4_define]))])dnl
#    __M4_DEFINE__([PREFIX_BINDIR_SUFFIX],[$(bindir)])dnl
#    __M4_DEFINE__([PREFIX_LIBDIR_SUFFIX],[$(libdir)])dnl
#    __M4_DEFINE__([PREFIX_PACKAGE_SUFFIX],[$(PACKAGE)])dnl
#
# to standard output. Thus you can put something like
#
#    m4_define([__M4_DEFINE__], [m4_defn([AC_DEFUN])])
#
# early on, to use AC_DEFUN, or some other macro, instead of
# m4_define. You could also use m4_pushdef and m4_popdef, instead of
# m4_define.
#
# You can leave out the third (`_SUFFIX') argument.
#
# (Occurences of '' and "" are to stop Autoconf from confusing the
# echoed text with stray M4sugar macros, without the use of
# m4_pattern_allow.)
configmake-m4sugar-defines = echo 'm''4_ifndef(@<:@__M4_DEFINE__@:>@,@<:@m''4_define(@<:@__M4_DEFINE__@:>@,m''4_defn(@<:@m''4_define@:>@))@:>@)d''nl';if :; then $(foreach dirvar, $(2), $(call __configmake_m4sugardef, $(1), $(dirvar), $(3));) fi
__configmake_m4sugardef = printf "__M4_DEFINE__(@<:@%s@:>@,@<:@%s@:>@)d""nl\n" "$(strip $(1))$(shell echo $(strip $(2)) | LC_ALL=C tr '@<:@a-z@:>@' '@<:@A-Z@:>@')$(strip $(3))" "$(subst ",\",$($(strip $(2))))"
#"

# FIXME: Document this.
configmake-vars-list = $(strip $(join $(patsubst %,@<:@@<:@%@:>@$(shell printf ","),$(2)),$(patsubst %,@<:@$(strip $(1))%$(strip $(3))@:>@@:>@,$(shell echo $(2) | LC_ALL=C tr '@<:@a-z@:>@' '@<:@A-Z@:>@'))))

# FIXME: Document this.
define __configmake_rule_template =
#
$(strip $(1))-h-rule = $$(eval $(call __configmake_toupper,$(strip $(1)))_LIST ?= $$(call configmake-vars-list, $$(2), $$(3) $$(4)))$$(if $$(strip $$($(call __configmake_toupper,$(1))_LIST)),$$(call configmake-h-rule,$$(1),$(2),$$(2),$(call __configmake_toupper,$(1))_LIST $$(3),$$(4)),$$(call configmake-h-rule,$$(1),$(2),$$(2),$$(3),$$(4)))
#
$(strip $(1))-m$(shell printf '')4-rule = $$(eval $(call __configmake_toupper,$(strip $(1)))_LIST ?= $$(call configmake-vars-list, $$(2), $$(3) $$(4)))$$(if $$(strip $$($(call __configmake_toupper,$(1))_LIST)),$$(call configmake-m4-rule,$$(1),$(2),$$(2),$(call __configmake_toupper,$(1))_LIST $$(3),$$(4)),$$(call configmake-m4-rule,$$(1),$(2),$$(2),$$(3),$$(4)))
#
$(strip $(1))-scm-rule = $$(eval $(call __configmake_toupper,$(strip $(1)))_LIST ?= $$(call configmake-vars-list, $$(2), $$(3) $$(4)))$$(if $$(strip $$($(call __configmake_toupper,$(1))_LIST)),$$(call configmake-scm-rule,$$(1),$$(2),$(2),$$(3),$(call __configmake_toupper,$(1))_LIST $$(4),$$(5)),$$(call configmake-scm-rule,$$(1),$$(2),$(2),$$(3),$$(4),$$(5)))
#
endef
__configmake_toupper = $(shell echo '$(strip $(1))' | LC_ALL=C tr '@<:@a-z@:>@' '@<:@A-Z@:>@')
$(eval $(call __configmake_rule_template,pkginfo,Package information for $(PACKAGE_NAME).))
$(eval $(call __configmake_rule_template,dirlayout,Directory layout of $(PACKAGE_NAME).))
$(eval $(call __configmake_rule_template,confopts,Configuration options that were chosen for $(PACKAGE_NAME).))

# FIXME: Document this.
define configmake-h-rule =
$(strip $(1)):
	$$(call v, CONFMK)( set -e; \
	$$(MKDIR_P) $$(@D); \
	{ \
	  echo '/* $(2) */'; \
	  echo; \
	  $(if $(strip $(4)$(5)),:,echo '/* This header file has nothing in it. */'); \
	  $(if $(strip $(4)),$(call configmake-c-defines, $(3), $(4));) \
	  $(if $(strip $(4)),$(call configmake-c-defines-utf8, $(3), $(4), _IN_UTF8);) \
	  $(if $(strip $(5)),$(call configmake-c-defines-unquoted, $(3), $(5));) \
	} > $$(@)-tmp; \
	mv $$(@)-tmp $$(@) )
endef

# FIXME: Document this.
define configmake-m4-rule =
$(strip $(1)):
	$$(call v, CONFMK)( set -e; \
	$$(MKDIR_P) $$(@D); \
	{ \
	  echo 'd''nl  $(2)'; \
	  echo 'd''nl'; \
	  $(if $(strip $(4)$(5)),:,echo 'd''nl  This m4 file has nothing in it.'); \
	  $(if $(strip $(4)$(5)),$(call configmake-m4sugar-defines, $(3), $(4) $(5));) \
	} > $$(@)-tmp; \
	mv $$(@)-tmp $$(@) )
endef

# FIXME: Document this.
define configmake-scm-rule =
$(strip $(1)): ; \
	$$(call v, CONFMK)( set -e; \
	$$(MKDIR_P) $$(@D); \
	{ \
	  echo ';; $(3)  -*- coding: utf-8 -*-'; \
	  echo; \
		      echo '(library ($(strip $(2)))'; \
	  echo; \
	  echo '(export $$(addprefix $(4),$$(strip $(shell echo $(5) $(6) | LC_ALL=C tr \"@<:@a-z@:>@\" \"@<:@A-Z@:>@\"))))'; \
	  echo; \
	  echo '(import (rnrs base))'; \
	  echo; \
	  $(if $(strip $(5)$(6)),:,echo ';;;';echo ';;; This library has nothing in it.';echo ';;;';echo); \
	  $(if $(strip $(5)),$(call configmake-scheme-defines, $(4), $(5));) \
	  $(if $(strip $(6)),$(call configmake-scheme-defines-unquoted, $(4), $(6));) \
	  echo ')'; \
	} > $$(@)-tmp; \
	mv $$(@)-tmp $$(@) )
endef

#--------------------------------------------------------------------------],[\$`])
_____StM_EOF_EOF_EOF_EOF_EOF_EOF_____
])
m4_changecom([#])
fi])
