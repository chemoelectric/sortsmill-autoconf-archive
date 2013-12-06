# -*- mode: makefile-gmake; coding: utf-8 -*-
#
# serial 10
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
AC_REQUIRE([StM_PROG_MSGFMT])
AC_REQUIRE([StM_PROG_MSGMERGE])
AC_REQUIRE([StM_PROG_XGETTEXT])
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
#
# Extraction of that parts of Make rules.
#
# FIXME: The following definitions likely will not do what is wanted
# if the ‘recipe’ part is present and contains quotations.

# Examples:
#
#    $(call rule-targets, a b c : d e | f g; recipe)
#
#    $(call rule-targets, a b c :: d e | f g; recipe)
#
# both will return ‘a b c’.
#
rule-targets = $(strip $(shell printf '%s' "$(1)" | \
	$(or $(SED),sed) 's/^\(@<:@^:@:>@@<:@^:@:>@*\)\(\|:\):.*/\1/'))

# Examples:
#
#    $(call rule-prerequisites, a b c : d e | f g; recipe)
#
#    $(call rule-prerequisites, a b c :: d e | f g; recipe)
#
# both will return ‘d e’.
#
rule-prerequisites = $(strip $(shell printf '%s' "$(1)" | \
	$(or $(SED),sed) 's/^@<:@^:@:>@@<:@^:@:>@*\(\|:\):\(@<:@^|;@:>@*\).*/\2/'))

# Examples:
#
#    $(call rule-order-only-prerequisites, a b c : d e | f g; recipe)
#
#    $(call rule-order-only-prerequisites, a b c :: d e | f g; recipe)
#
# both will return ‘f g’.
#
rule-order-only-prerequisites = $(strip $(shell printf '%s' "$(1)" | \
	$(or $(SED),sed) 's/^@<:@^:@:>@@<:@^:@:>@*\(\|:\):@<:@^|@:>@*\(\||\)\(@<:@^;@:>@*\).*/\3/'))

# Examples:
#
#    $(call rule-recipe, a b c : d e | f g; recipe)
#
#    $(call rule-recipe, a b c :: d e | f g; recipe)
#
# both will return ‘ recipe’.
#
rule-recipe = $(shell printf '%s' "$(1)" | $(or $(SED),sed) 's/^@<:@^;@:>@*\(;\|\)\(.*\)/\2/')

#--------------------------------------------------------------------------
#
# Macro ‘prefixed-install’ lets you do something like Automake’s
# ‘nobase_’, but for files stored in some subdirectory (the ‘prefix’)
# whose path you _do not_ wish to replicate at the point of
# installation.
#
# Example of use:
#
#    EXTRA_DIST =
#
#    $(call prefixed-install, my-prefix/path, include, HEADER)
#    install-data-local: install-prefixed_my_prefix_path_include_HEADERZ
#    uninstall-local: uninstall-prefixed_my_prefix_path_include_HEADERZ
#
#    prefixed_my_prefix_path_include_HEADERZ = a/b/c.h d.h
#    prefixed_my_prefix_path_dist_include_HEADERZ = e/f.h
#    prefixed_my_prefix_path_nodist_include_HEADERZ = aa/b/c.h dd.h e/ff.h
#
# Once can use, for instance, ‘install-data-hook’ instead of
# ‘install-data-local’, to tailor the behavior.
#
# Notice the (mis)spelling with ‘Z’ instead of ‘S’. If we had used an
# ‘S’, Automake would have intercepted the variable, which is not what
# we want. Similarly, one would write prefixed_foo_bar_DATAZ,
# prefixed_foo_bar_PROGRAMZ, or prefixed_foo_bar_SCRIPTZ.
#
# BUGS: Currently we cannot handle libraries.
#
# Limitations: The following code requires special handling for file
# names containing spaces, commas, and so forth, but this is true in
# general in GNUmakefiles.

prefixed-install = \
	$(eval $$(call stm__prefixed_install,$(1),$(2),$(3))) \
	$(eval $$(call stm__prefixed_uninstall,$(1),$(2),$(3))) \
	$(eval $$(call stm__prefixed_distribute,$(1),$(2),$(3))) \
	$(eval .PHONY: $$(call stm__all_prefixed_vars,$(1),$(2),$(3)))

# FIXME: This stm__prefixed_install is inadequate for libraries, which
# must be installed with libtool.
#
# FIXME: Replace the expr here with printf.
#
define stm__prefixed_install =
install-$(call stm__prefixed_var,$(1),$(2),$(3)): \
		$(addprefix $(strip $(1))/,$(call stm__expand_all_prefixed_vars,$(1),$(2),$(3))); \
	$(if $(strip $(call stm__expand_all_prefixed_vars,$(1),$(2),$(3))), \
		@if :; then \
			$(foreach d, $(sort $(dir $(call stm__expand_all_prefixed_vars,$(1),$(2),$(3)))), \
				echo " $(MKDIR_P) '$(DESTDIR)$($(strip $(2))dir)/$(d)'"; \
				$(MKDIR_P) '$(DESTDIR)$($(strip $(2))dir)/$(d)';) \
		fi; \
		if :; then \
			$(foreach f, $(call stm__expand_all_prefixed_vars,$(1),$(2),$(3)), \
				printf '%s\n' " $(INSTALL_$(strip $(3))) '$(call find,$(strip $(1))/$(f))' \
					'$(DESTDIR)$($(strip $(2))dir)/$(dir $(f))'"; \
				$(INSTALL_$(strip $(3))) '$(call find,$(strip $(1))/$(f))' \
					'$(DESTDIR)$($(strip $(2))dir)/$(dir $(f))' || exit $$$$?;) \
		fi)
endef

# FIXME: This stm__prefixed_uninstall is inadequate for libraries,
# which must be installed with libtool.
define stm__prefixed_uninstall =
uninstall-$(call stm__prefixed_var,$(1),$(2),$(3)): ; \
	$(if $(strip $(call stm__expand_all_prefixed_vars,$(1),$(2),$(3))), \
		-@if :; then \
			$(patsubst %,expr " rm -f '$(DESTDIR)$($(strip $(2))dir)/%'" : '\(.*\)';, \
				$(call stm__expand_all_prefixed_vars,$(1),$(2),$(3))) \
			$(patsubst %,rm -f '$(DESTDIR)$($(strip $(2))dir)/%';, \
				$(call stm__expand_all_prefixed_vars,$(1),$(2),$(3))) \
		fi)
endef

stm__prefixed_distribute = \
	$(eval EXTRA_DIST += $(addprefix $(strip $(1))/,\
		$(call stm__expand_dist_prefixed_vars,$(1),$(2),$(3))))

stm__prefix_to_var = \
	$(shell printf '%s' '$(strip $(1))' | \
		$(or $(SED),sed) -e 's%[[^_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789]]%_%g')

stm__prefixed_var = prefixed_$(call stm__prefix_to_var,$(1))_$(strip $(2))_$(strip $(3))Z
stm__prefixed_dist_var = prefixed_$(call stm__prefix_to_var,$(1))_dist_$(strip $(2))_$(strip $(3))Z
stm__prefixed_nodist_var = prefixed_$(call stm__prefix_to_var,$(1))_nodist_$(strip $(2))_$(strip $(3))Z
stm__all_prefixed_vars = \
	$(call stm__prefixed_var,$(1),$(2),$(3)) \
	$(call stm__prefixed_dist_var,$(1),$(2),$(3)) \
	$(call stm__prefixed_nodist_var,$(1),$(2),$(3))
stm__expand_all_prefixed_vars = \
	$($(call stm__prefixed_var,$(1),$(2),$(3))) \
	$($(call stm__prefixed_dist_var,$(1),$(2),$(3))) \
	$($(call stm__prefixed_nodist_var,$(1),$(2),$(3)))
stm__expand_dist_prefixed_vars = \
	$($(call stm__prefixed_var,$(1),$(2),$(3))) \
	$($(call stm__prefixed_dist_var,$(1),$(2),$(3)))

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
#
# Silent rules macros.

# $(call if-silent,...do-this-if-silent...[,...do-this-if-not-silent])
#
# $(call if-not-silent,...do-this-if-not-silent...[,...do-this-if-silent])
#
# DEFAULT_VERBOSITY (or, if that is not set, AM_DEFAULT_VERBOSITY)
# should be set to 0, if you want ‘silent’ by default.
#
# Setting V=0 or V=1 on the command line works as with silent rules in
# Automake.
#
if-silent = $(if $(filter 0,$(or $(V),$(if $(filter-out $(flavor DEFAULT_VERBOSITY),undefined),$(DEFAULT_VERBOSITY),$(AM_DEFAULT_VERBOSITY)))),$(1),$(2))
if-not-silent = $(call if-silent,$(2),$(1))

# $(call v,...) examples:
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
v = $(call if-silent,@printf "  %-8s %s\n" $(1) $(@);)

#--------------------------------------------------------------------------

# The ln-man-to-man macro creates a rule to link one manpage to one or
# more equivalent manpages, by the .so method.
#
# Usage of the macro:
#
#    $(eval $(call ln_man_to_man, common/path/prefix, \
#        manN/manpage_a.N, manN/manpage_b.N manN/manpage_c.N ..., \
#        [extra_dependency1 extra_dependency2 ...]))
#
# The $(eval ...) is not necessarily needed, depending on where you
# use the macro; I believe, however, that it will not hurt.
#
ln-man-to-man = $(addprefix $(strip $(1))/,$(3)): $(addprefix $(strip $(1))/,$(2)) $(4); echo '.so $(strip $(2))' > $$(@)

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
# You can leave out the third (‘_SUFFIX’) argument.
#
# If you call
#
#    $(call configmake-c-defines-utf8, PREFIX_, bindir libdir PACKAGE, _IN_UTF8)
#
# the result is code to ‘#define’ PREFIX_BINDIR_IN_UTF8,
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
# escaped. (Guile 2.0 respects Emacs-style ‘-*-coding:utf-8;-*-' and
# similar notations near the tops of source files.)
#
# You can leave out the third (‘_SUFFIX') argument.
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
# You can leave out the third (‘_SUFFIX') argument.
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
$(eval $(call __configmake_rule_template,confopts,$$(warning WARNING: confopts is DEPRECATED. Use buildinfo instead.)Configuration options that were chosen for $(PACKAGE_NAME).))
$(eval $(call __configmake_rule_template,buildinfo,Miscellaneous build information for $(PACKAGE_NAME).))

# FIXME: Document this.
configmake-buildinfopy-rules = $(eval $(call __configmake_rule_template,buildinfopy$(subst .,_,$(strip $(1))),Miscellaneous Python $(subst _,.,$(strip $(1)))-related build information for $(PACKAGE_NAME).))

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

#--------------------------------------------------------------------------
#
# GNU gettext support.

# msgfmt-rule example:
#
#   $(call msgfmt-rule, \
#       %/LC_MESSAGES/mydomain.mo: $(srcdir)/%.po, \
#	    --check)
#
# This expands to the equivalent of:
#
#   en_US/LC_MESSAGES/mydomain.mo: $(srcdir)/en_US.po
#       mkdir -p en_US/LC_MESSAGES/
#       msgfmt --check -o en_US/LC_MESSAGES/mydomain.mo $(srcdir)/en_US.po
#
msgfmt-rule = $(strip $(1)); \
	$$(call v, MSGFMT)$$(MKDIR_P) $$(@D) && $$(or $$(MSGFMT),msgfmt) $(2) -o $$(@) $$(<)

# msgmerge-rule example:
#
#   $(call msgmerge-rule, \
#       $(srcdir)/en_US.po $(srcdir)/fr_FR.po: $(srcdir)/mydomain.pot, \
#       --backup=numbered)
#
# This expands to the equivalent of:
#
#   $(srcdir)/en_US.po: $(srcdir)/mydomain.pot
#       msgmerge --backup=numbered --update --force-po $(srcdir)/en_US.po $(srcdir)/mydomain.pot
#       touch $(srcdir)/en_US.po
#
msgmerge-rule = $(strip $(1)); \
	$$(call v, MSGMERGE)$$(or $$(MSGMERGE),msgmerge) $(2) $(call if-silent,--quiet) --update --force-po $$(@) $$(<) \
		&& touch $$(@)

# xgettext-rule example:
#
#   $(call xgettext-rule, \
#       $(srcdir)/mydomain.pot: srcfile1.scm srcfile2.c srcfile3.h, \
#       --keyword=_ --keyword=N_ --add-location --from-code=UTF-8)
#
# Roughly, this expands to:
#
#   $(srcdir)/mydomain.pot: srcfile1.scm srcfile2.c srcfile3.h
#       xgettext -o mydomain.pot-tmp --keyword=_ --keyword=N_ \
#                --add-location --from-code=UTF-8 --force-po $^ \
#       if test -f $(srcdir)/mydomain.pot; then \
#           sed -e '/^"POT-Creation-Date:/{d;q}' $(srcdir)/mydomain.pot > mydomain.pot-datelesstmp; \
#           sed -e '/^"POT-Creation-Date:/{d;q}' mydomain.pot-tmp > mydomain.pot-tmp-datelesstmp; \
#           if cmp mydomain.pot-datelesstmp mydomain.pot-tmp-datelesstmp; then \
#               touch $(srcdir)/mydomain.pot; \
#           else \
#               mv mydomain.pot-tmp $(srcdir)/mydomain.pot; \
#           fi; \
#	    else \
#           mv mydomain.pot-tmp $(srcdir)/mydomain.pot; \
#       fi
#	    rm -f mydomain.pot-tmp mydomain.pot-datelesstmp mydomain.pot-tmp-datelesstmp
#
# The effect is merely to touch the POT file if it exists and would
# not change except for POT-Creation-Date; otherwise to create or
# re-create the file.
#
# Implementation note: the main reason the following macro updates the
# POT file only if the file has changed is that, otherwise, ‘make
# distcheck’ will fail, from the attempt to write into the $(srcdir).
xgettext-rule = $(strip $(1)); \
	$$(call v, XGETTEXT)$$(or $$(XGETTEXT),xgettext) -o $$(@F)-tmp $(2) --force-po $$(^) && \
	if test -f '$$(@)'; then \
		$$(or $$(SED),sed) -e '/^\"POT-Creation-Date:/{d;q}' $$(@) > $$(@F)-datelesstmp && \
		$$(or $$(SED),sed) -e '/^\"POT-Creation-Date:/{d;q}' $$(@F)-tmp > $$(@F)-tmp-datelesstmp && \
		if cmp $$(@F)-datelesstmp $$(@F)-tmp-datelesstmp 2> /dev/null > /dev/null; then \
			touch $$(@); \
		else \
			mv $$(@F)-tmp $$(@); \
		fi; \
	else \
		mv $$(@F)-tmp $$(@); \
	fi; \
	rm -f $$(@F)-tmp $$(@F)-tmp-datelesstmp $$(@F)-datelesstmp

#--------------------------------------------------------------------------],[\$`])
_____StM_EOF_EOF_EOF_EOF_EOF_EOF_____
])
m4_changecom([#])
fi])
