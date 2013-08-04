# -*- autoconf -*-
#
# Copyright (C) 2013 Khaled Hosny and Barry Schwartz
# 
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# serial 1

# FIXME: Document this macro.

# StM_MAKE_README(subst-var, manpage, [readme-file-var = `PACKAGE_README'], [readme-target = `readme'])
# -----------------------------------------------------------------------------------------------------
AC_DEFUN([StM_MAKE_README],[
   $1="
.PHONY: m4_ifval([$4],[$4],[readme])
m4_ifval([$4],[$4],[readme]): $2
dnl Turn off justification.
	echo '.na' >  stm_make_readme.nr-tmp
	echo '.de ad' >> stm_make_readme.nr-tmp
	echo '..' >> stm_make_readme.nr-tmp
dnl Turn off hyphenation.
	echo '.nh' >> stm_make_readme.nr-tmp
	echo '.de hy' >> stm_make_readme.nr-tmp
	echo '..' >> stm_make_readme.nr-tmp
	cat stm_make_readme.nr-tmp $2 | groff -man -Tascii -P -c -P -b -P -u -i > stm_make_readme.readme-tmp
	mv stm_make_readme.readme-tmp \@S|@(m4_ifval([$3],[$3],[PACKAGE_README]))
	rm -f stm_make_readme.nr-tmp
"
   AC_SUBST([$1])
   AM_SUBST_NOTMAKE([$1])
])
