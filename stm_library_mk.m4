# -*- makefile-gmake; coding: utf-8 -*-
#
# serial 1
#
m4_define([_StM_LIBRARY_MK_COPYRIGHT],
[# -*- makefile-gmake; coding: utf-8 -*-
#
# Copyright (C) 2013 Khaled Hosny and Barry Schwartz
# 
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.])

AC_DEFUN([StM_LIBRARY_MK], [if :; then
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
				| sed 's%[[^ 	]][[^ 	]]*/[[^ 	]]*%%g')))

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

#--------------------------------------------------------------------------],[\$`])
_____StM_EOF_EOF_EOF_EOF_EOF_EOF_____
])
m4_changecom([#])
fi])
