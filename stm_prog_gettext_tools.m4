# -*- autoconf -*-
#
# Copyright (C) 2013 Khaled Hosny and Barry Schwartz
# 
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# serial 2

# StM_PROG_XGETTEXT, StM_PROG_MSGMERGE, etc.
# ------------------------------------------
#
# Set XGETTEXT (MSGMERGE, ...) to the path of the first xgettext
# (msgmerge, ...) in the PATH, or to an empty string if xgettext
# (msgmerge, ...) is not found. The result is cached in
# ac_cv_path_XGETTEXT (ac_cv_path_MSGMERGE, ...). The test may be
# overridden by setting XGETTEXT (MSGMERGE, ...) or the cache
# variable.
#
AC_DEFUN([_stm_gettext_tools_prog],[{ :
   AC_REQUIRE([AC_PROG_GREP])
   m4_pushdef([_tool],AS_TR_SH(m4_car(m4_translit(m4_normalize([$1]),[ ],[,]))))
   m4_pushdef([_TOOL],m4_toupper(_tool))
   StM_PATH_PROGS_CACHED_AND_PRECIOUS(_TOOL,[GNU ]_tool[ command],
      [$1],[
         if LC_ALL=C LANG=C ${ac_path_]_TOOL[} --version | \
                 LC_ALL=C LANG=C ${GREP} '(GNU gettext-tools)' 2> /dev/null > /dev/null; then
            ac_cv_path_]_TOOL[=${ac_path_]_TOOL[}
            ac_path_]_TOOL[_found=:
         fi
      ])
   m4_popdef([_TOOL])
   m4_popdef([_tool])
}])
AC_DEFUN([StM_PROG_XGETTEXT], [_stm_gettext_tools_prog([xgettext])])
AC_DEFUN([StM_PROG_MSGMERGE], [_stm_gettext_tools_prog([msgmerge])])
AC_DEFUN([StM_PROG_GETTEXT], [_stm_gettext_tools_prog([gettext])])
AC_DEFUN([StM_PROG_NGETTEXT], [_stm_gettext_tools_prog([ngettext])])
AC_DEFUN([StM_PROG_GETTEXTIZE], [_stm_gettext_tools_prog([gettextize])])
AC_DEFUN([StM_PROG_MSGUNIQ], [_stm_gettext_tools_prog([msguniq])])
AC_DEFUN([StM_PROG_MSGINIT], [_stm_gettext_tools_prog([msginit])])
AC_DEFUN([StM_PROG_MSGGREP], [_stm_gettext_tools_prog([msggrep])])
AC_DEFUN([StM_PROG_MSGFILTER], [_stm_gettext_tools_prog([msgfilter])])
AC_DEFUN([StM_PROG_MSGEXEC], [_stm_gettext_tools_prog([msgexec])])
AC_DEFUN([StM_PROG_MSGEN], [_stm_gettext_tools_prog([msgen])])
AC_DEFUN([StM_PROG_MSGCONV], [_stm_gettext_tools_prog([msgconv])])
AC_DEFUN([StM_PROG_MSGCOMM], [_stm_gettext_tools_prog([msgcomm])])
AC_DEFUN([StM_PROG_MSGCAT], [_stm_gettext_tools_prog([msgcat])])
AC_DEFUN([StM_PROG_MSGATTRIB], [_stm_gettext_tools_prog([msgattrib])])
AC_DEFUN([StM_PROG_MSGUNFMT], [_stm_gettext_tools_prog([msgunfmt])])
AC_DEFUN([StM_PROG_MSGFMT], [_stm_gettext_tools_prog([msgfmt gmsgfmt])])
AC_DEFUN([StM_PROG_MSGCMP], [_stm_gettext_tools_prog([msgcmp])])
AC_DEFUN([StM_PROG_ENVSUBST], [_stm_gettext_tools_prog([envsubst])])
AC_DEFUN([StM_PROG_RECODE_SR_LATIN], [_stm_gettext_tools_prog([recode-sr-latin])])
