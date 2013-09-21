# -*- autoconf -*-
#
# Copyright (C) 2013 Khaled Hosny and Barry Schwartz
# 
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# serial 2

# StM_RULE_TARGETS_MACRO(gnu_make_macro_name)
# -------------------------------------------
#
# If you put
#
#    StM_RULE_TARGETS_MACRO(rule_targets)
#
# in configure.ac, then in your Makefile you can put
#
#    $(call rule_targets, a b c : d e | f g; recipe)
#
# or
#
#    $(call rule_targets, a b c :: d e | f g; recipe)
#
# or something similar and get back `a b c'.
#
AC_DEFUN([StM_RULE_TARGETS_MACRO],[if true; then
   AC_REQUIRE([AC_PROG_SED])
   AC_SUBST([$1],
      ["\$(strip \$(shell expr \"X\$(1)\" : 'X\(.*\)' | \
                          \$(SED) 's/^\(@<:@^:@:>@@<:@^:@:>@*\)\(\|:\):.*/\1/'))"])
fi])

# StM_RULE_PREREQUISITES_MACRO(gnu_make_macro_name)
# -------------------------------------------------
#
#
# If you put
#
#    StM_RULE_PREREQUISITES_MACRO(rule_prerequisites)
#
# in configure.ac, then in your Makefile you can put
#
#    $(call rule_prerequisites, a b c : d e | f g; recipe)
#
# or
#
#    $(call rule_prerequisites, a b c :: d e | f g; recipe)
#
# or something similar and get back `d e'.
#
AC_DEFUN([StM_RULE_PREREQUISITES_MACRO],[if true; then
   AC_REQUIRE([AC_PROG_SED])
   AC_SUBST([$1],
      ["\$(strip \$(shell expr \"X\$(1)\" : 'X\(.*\)' | \
                          \$(SED) 's/^@<:@^:@:>@@<:@^:@:>@*\(\|:\):\(@<:@^|;@:>@*\).*/\2/'))"])
fi])

# StM_RULE_ORDER_ONLY_PREREQUISITES_MACRO(gnu_make_macro_name)
# ------------------------------------------------------------
#
# If you put
#
#    StM_RULE_ORDER_ONLY_PREREQUISITES_MACRO(rule_order_only_prerequisites)
#
# in configure.ac, then in your Makefile you can put
#
#    $(call rule_order_only_prerequisites, a b c : d e | f g; recipe)
#
# or
#
#    $(call rule_order_only_prerequisites, a b c :: d e | f g; recipe)
#
# or something similar and get back `f g'.
#
AC_DEFUN([StM_RULE_ORDER_ONLY_PREREQUISITES_MACRO],[if true; then
   AC_REQUIRE([AC_PROG_SED])
   AC_SUBST([$1],
      ["\$(strip \$(shell expr \"X\$(1)\" : 'X\(.*\)' | \
                          \$(SED) 's/^@<:@^:@:>@@<:@^:@:>@*\(\|:\):@<:@^|@:>@*\(\||\)\(@<:@^;@:>@*\).*/\3/'))"])
fi])


# StM_RULE_RECIPE_MACRO(gnu_make_macro_name)
# ------------------------------------------
#
# If you put
#
#    StM_RULE_RECIPE_MACRO(rule_recipe)
#
# in configure.ac, then in your Makefile you can put
#
#    $(call rule_recipe, a b c : d e | f g; recipe)
#
# or
#
#    $(call rule_recipe, a b c :: d e | f g; recipe)
#
# or something similar and get back ` recipe'.
#
AC_DEFUN([StM_RULE_RECIPE_MACRO],[if true; then
   AC_REQUIRE([AC_PROG_SED])
   AC_SUBST([$1],
      ["\$(shell expr \"X\$(1)\" : 'X\(.*\)' | \
                 \$(SED) 's/^@<:@^;@:>@*\(;\|\)\(.*\)/\2/')"])
fi])

# StM_RULE_PARTS_MACROS
# ---------------------
#
# Define `rule_targets', `rule_prerequisites',
# `rule_order_only_prerequisites', and `rule_recipe' as shown above in
# the descriptions of the individual rule-parts Autoconf macros.
#
AC_DEFUN([StM_RULE_PARTS_MACROS],[if true; then
   StM_RULE_TARGETS_MACRO([rule_targets])
   StM_RULE_PREREQUISITES_MACRO([rule_prerequisites])
   StM_RULE_ORDER_ONLY_PREREQUISITES_MACRO([rule_order_only_prerequisites])
   StM_RULE_RECIPE_MACRO([rule_recipe])
fi])
