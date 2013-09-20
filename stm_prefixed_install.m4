# -*- autoconf -*-
#
# Copyright (C) 2013 Khaled Hosny and Barry Schwartz
# 
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# serial 3

# StM_PREFIXED_INSTALL
# --------------------
#
# AC_SUBST the GNU Make variables `prefixed_install' and
# `prefixed_uninstall', that let you do something like Automake's
# `nobase_', but for files stored in some subdirectory (the `prefix')
# whose path you _do not_ wish to replicate at the point of
# installation.
#
# Example of use:
#
#    EXTRA_DIST =
#
#    $(call prefixed_install, my-prefix/path, include, HEADER)
#    install-data-local: install-prefixed_my_prefix_path_include_HEADERZ
#    uninstall-local: uninstall-prefixed_my_prefix_path_include_HEADERZ
#
#    prefixed_my_prefix_path_include_HEADERZ = a/b/c.h d.h
#    prefixed_my_prefix_path_dist_include_HEADERZ = e/f.h
#    prefixed_my_prefix_path_nodist_include_HEADERZ = aa/b/c.h dd.h e/ff.h
#
# Once can use, for instance, `install-data-hook' instead of
# `install-data-local', to tailor the behavior.
#
# Notice the (mis)spelling with `Z' instead of `S'. If we had used an
# `S', Automake would have intercepted the variable, which is not what
# we want. Similarly, one would write prefixed_foo_bar_DATAZ,
# prefixed_foo_bar_PROGRAMZ, or prefixed_foo_bar_SCRIPTZ.
#
# BUGS: Currently we cannot handle libraries.
#
AC_DEFUN([StM_PREFIXED_INSTALL], [if true; then
   AC_REQUIRE([AC_PROG_SED])

   # The following code requires special handling for file names
   # containing spaces, commas, and so forth, but this is true in
   # general in GNUmakefiles.

   AC_SUBST([prefixed_install],
      ["AS_ESCAPE([$(eval $$(call stm__prefixed_install,$(1),$(2),$(3)))   \
                   $(eval $$(call stm__prefixed_uninstall,$(1),$(2),$(3))) \
                   $(eval $$(call stm__prefixed_distribute,$(1),$(2),$(3)))])"])

   # FIXME: This is inadequate for libraries, which must be installed
   # with libtool.
   AC_SUBST([stm__prefixed_install],
   ["AS_ESCAPE([install-$(call stm__prefixed_var,$(1),$(2),$(3)): \
        $(addprefix $(strip $(1))/,$(call stm__expand_all_prefixed_vars,$(1),$(2),$(3))); \
    $(if $(strip $(call stm__expand_all_prefixed_vars,$(1),$(2),$(3))), \
       @if true; then \
          $(foreach f, $(call stm__expand_all_prefixed_vars,$(1),$(2),$(3)), \
             $(MKDIR_P) '$(DESTDIR)$($(strip $(2))dir)/$(dir $(f))'; \
             expr "$(INSTALL_$(strip $(3))) '$(call stm__prefixed_install__find,$(strip $(1))/$(f))' '$(DESTDIR)$($(strip $(2))dir)/$(dir $(f))'" : '\(.*\)'; \
             $(INSTALL_$(strip $(3))) '$(call stm__prefixed_install__find,$(strip $(1))/$(f))' \
                '$(DESTDIR)$($(strip $(2))dir)/$(dir $(f))' || exit $$$$?;) \
       fi)])"])

   # FIXME: This is inadequate for libraries, which must be installed
   # with libtool.
   AC_SUBST([stm__prefixed_uninstall],
   ["AS_ESCAPE([uninstall-$(call stm__prefixed_var,$(1),$(2),$(3)): ; \
    $(if $(strip $(call stm__expand_all_prefixed_vars,$(1),$(2),$(3))), \
        -@if true; then \
            $(patsubst %,expr "rm -f '$(DESTDIR)$($(strip $(2))dir)/%'" : '\(.*\)'; \
                         rm -f '$(DESTDIR)$($(strip $(2))dir)/%';, \
              $(call stm__expand_all_prefixed_vars,$(1),$(2),$(3))) \
        fi)])"])

   AC_SUBST([stm__prefixed_distribute],
            ["AS_ESCAPE([$(eval EXTRA_DIST += $(addprefix $(strip $(1))/,\
                $(call stm__expand_dist_prefixed_vars,$(1),$(2),$(3))))])"])

   # `expr' is used here as an echo that ignores flags and escapes
   # such as `\c'.
   AC_SUBST([stm__prefix_to_var],
            ["AS_ESCAPE([$(shell expr 'X$(strip $(1))' : 'X\(.*\)' | \
                $(SED) -e 's%[[^_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789]]%_%g')])"])

   AC_SUBST([stm__prefixed_var],
      ["AS_ESCAPE(prefixed_$(call stm__prefix_to_var,$(1))_$(strip $(2))_$(strip $(3))Z)"])
   AC_SUBST([stm__prefixed_dist_var],
      ["AS_ESCAPE(prefixed_$(call stm__prefix_to_var,$(1))_dist_$(strip $(2))_$(strip $(3))Z)"])
   AC_SUBST([stm__prefixed_nodist_var],
      ["AS_ESCAPE(prefixed_$(call stm__prefix_to_var,$(1))_nodist_$(strip $(2))_$(strip $(3))Z)"])
   AC_SUBST([stm__expand_all_prefixed_vars],
      ["AS_ESCAPE($($(call stm__prefixed_var,$(1),$(2),$(3))) \
                  $($(call stm__prefixed_dist_var,$(1),$(2),$(3))) \
                  $($(call stm__prefixed_nodist_var,$(1),$(2),$(3))))"])
   AC_SUBST([stm__expand_dist_prefixed_vars],
      ["AS_ESCAPE($($(call stm__prefixed_var,$(1),$(2),$(3))) \
                  $($(call stm__prefixed_dist_var,$(1),$(2),$(3))))"])

   # FIXME: This is reusable if given a different name. Finds a file
   # in the current directory or otherwise in the VPATH.
   AC_SUBST([stm__prefixed_install__find],
      ["AS_ESCAPE([$(if $(realpath $(1)),$(1),$(call stm__prefixed_install__find_in_path,$(1),$(VPATH)))])"])
   AC_SUBST([stm__prefixed_install__find_in_path],
      ["AS_ESCAPE([$(call stm__prefixed_install__find_in_dirlist,$(1),$(subst :, ,$(2)))])"])
   AC_SUBST([stm__prefixed_install__find_in_dirlist],
      ["AS_ESCAPE([$(if $(strip $(2)),$(if $(realpath $(firstword $(2))/$(1)),$(2)/$(1),$(call stm__prefixed_install__find_in_dirlist,$(1),$(wordlist 2,$(words $(2)),$(2)))))])"])
fi])
