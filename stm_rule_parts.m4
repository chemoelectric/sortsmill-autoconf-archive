# -*- autoconf -*-
#
# Copyright (C) 2013 Khaled Hosny and Barry Schwartz
# 
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# serial 1

# StM_RULE_TARGETS_MACRO(gnu_make_macro_name [, echo_command = `echo'])
# ---------------------------------------------------------------------
#
# FIXME: Document this.
#
AC_DEFUN([StM_RULE_TARGETS_MACRO],[{ :
   dnl Let the user use a `safer' echo.
   m4_pushdef([_echo], m4_ifnblank([$2],[$2],echo))
   AC_SUBST([$1],["\@S|@(shell _echo \`_echo '\@S|@1' | sed 's/^\(@<:@^:@:>@@<:@^:@:>@*\)\(\|:\):.*/\1/'\`)"])
   m4_popdef([_echo])
}])

# StM_RULE_PREREQUISITES_MACRO(gnu_make_macro_name [, echo_command = `echo'])
# ---------------------------------------------------------------------------
#
# FIXME: Document this.
#
AC_DEFUN([StM_RULE_PREREQUISITES_MACRO],[{ :
   dnl Let the user use a `safer' echo.
   m4_pushdef([_echo], m4_ifnblank([$2],[$2],echo))
   AC_SUBST([$1],["\@S|@(shell _echo \`_echo '\@S|@1' | sed 's/^@<:@^:@:>@@<:@^:@:>@*\(\|:\):\(@<:@^|;@:>@*\).*/\2/'\`)"])
   m4_popdef([_echo])
}])

# StM_RULE_ORDER_ONLY_PREREQUISITES_MACRO(gnu_make_macro_name [, echo_command = `echo'])
# --------------------------------------------------------------------------------------
#
# FIXME: Document this.
#
AC_DEFUN([StM_RULE_ORDER_ONLY_PREREQUISITES_MACRO],[{ :
   dnl Let the user use a `safer' echo.
   m4_pushdef([_echo], m4_ifnblank([$2],[$2],echo))
   AC_SUBST([$1],["\@S|@(shell _echo \`_echo '\@S|@1' | sed 's/^@<:@^:@:>@@<:@^:@:>@*\(\|:\):@<:@^|@:>@*\(\||\)\(@<:@^;@:>@*\).*/\3/'\`)"])
   m4_popdef([_echo])
}])


# StM_RULE_RECIPE_MACRO(gnu_make_macro_name [, echo_command = `echo'])
# --------------------------------------------------------------------
#
# FIXME: Document this.
#
AC_DEFUN([StM_RULE_RECIPE_MACRO],[{ :
   dnl Let the user use a `safer' echo.
   m4_pushdef([_echo], m4_ifnblank([$2],[$2],echo))
   AC_SUBST([$1],["\@S|@(shell _echo \`_echo '\@S|@1' | sed 's/^@<:@^;@:>@*\(;\|\)\(.*\)/\2/'\`)"])
   m4_popdef([_echo])
}])

# StM_RULE_PARTS_MACROS([echo_command = `echo'])
# ----------------------------------------------
#
# FIXME: Document this.
#
AC_DEFUN([StM_RULE_PARTS_MACROS],[{ :
   StM_RULE_TARGETS_MACRO([rule_targets],[$1])
   StM_RULE_PREREQUISITES_MACRO([rule_prerequisites],[$1])
   StM_RULE_ORDER_ONLY_PREREQUISITES_MACRO([rule_order_only_prerequisites],[$1])
   StM_RULE_RECIPE_MACRO([rule_recipe],[$1])
}])
