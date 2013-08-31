# -*- autoconf -*-
#
# Copyright (C) 2013 Khaled Hosny and Barry Schwartz
# 
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# serial 1

# StM_MSGFMT_RULE(gnu_make_macro_name)
# ------------------------------------
#
# Example:
#
#   # In configure.ac:
#   StM_MSGFMT_RULE([my_msgfmt_rule])
#
#   # In Makefile.am, Makefile.in, or Makefile:
#   $(call my_msgfmt_rule, \
#       %/LC_MESSAGES/mydomain.mo: $(srcdir)/%.po, \
#	    --check)
#
#   # This expands, for instance, to the equivalent of:
#   en_US/LC_MESSAGES/mydomain.mo: $(srcdir)/en_US.po
#       mkdir -p en_US/LC_MESSAGES/
#       msgfmt --check -o en_US/LC_MESSAGES/mydomain.mo $(srcdir)/en_US.po
#
AC_DEFUN([StM_MSGFMT_RULE],[{ :
   AC_REQUIRE([StM_PROG_MSGFMT])
   AC_REQUIRE([AC_PROG_MKDIR_P])

   if test -z "${MSGFMT}"; then
      AC_MSG_ERROR([msgfmt from GNU gettext is required.
           Consider installing GNU gettext.
           GNU gettext homepage: <https://www.gnu.org/software/gettext/>])
   fi

   AC_SUBST([$1],
      ["\@S|@(strip \@S|@1); \@S|@\@S|@(MKDIR_P) '\@S|@\@S|@(dir \@S|@\@S|@@)' && \@S|@\@S|@(MSGFMT) \@S|@2 -o '\@S|@\@S|@@' '\@S|@\@S|@<'"])
}])

# StM_MSGMERGE_RULE(gnu_make_macro_name)
# --------------------------------------
#
# Example:
#
#   # In configure.ac:
#   StM_MSGMERGE_RULE([my_msgmerge_rule])
#
#   # In Makefile.am, Makefile.in, or Makefile:
#   $(call my_msgmerge_rule, \
#       $(srcdir)/en_US.po $(srcdir)/fr_FR.po, \
#       $(srcdir)/mydomain.pot, \
#       --backup=numbered, Makefile GNUmakefile)
#
#   # This expands, for instance, to the equivalent of:
#   $(srcdir)/en_US.po: $(srcdir)/mydomain.pot Makefile GNUmakefile
#       msgmerge --backup=numbered --update --force-po $(srcdir)/en_US.po $(srcdir)/mydomain.pot
#       touch $(srcdir)/en_US.po
#
AC_DEFUN([StM_MSGMERGE_RULE],[{ :
   AC_REQUIRE([StM_PROG_MSGMERGE])

   if test -z "${MSGMERGE}"; then
      AC_MSG_ERROR([msgmerge from GNU gettext is required.
           Consider installing GNU gettext.
           GNU gettext homepage: <https://www.gnu.org/software/gettext/>])
   fi

   AC_SUBST([$1],
      ["\@S|@(strip \@S|@1): \@S|@2 \@S|@4; \@S|@\@S|@(MSGMERGE) \@S|@3 --update --force-po '\@S|@\@S|@@' \@S|@2 && touch '\@S|@\@S|@@'"])
}])

# StM_XGETTEXT_RULE(gnu_make_macro_name)
# --------------------------------------
#
#   # In configure.ac:
#   StM_XGETTEXT_RULE([my_xgettext_rule])
#
#   # In Makefile.am, Makefile.in, or Makefile:
#   $(call my_xgettext_rule, \
#       $(srcdir)/mydomain.pot, srcfile1.scm srcfile2.c srcfile3.h, \
#       --keyword=_ --keyword=N_ --add-location --from-code=UTF-8, \
#       Makefile GNUmakefile)
#
# Roughly, this expands to:
#
#   $(srcdir)/mydomain.pot: srcfile1.scm srcfile2.c srcfile3.h Makefile GNUmakefile
#       xgettext -o mydomain.pot-tmp --keyword=_ --keyword=N_ \
#                --add-location --from-code=UTF-8 \
#                --force-po $(filter-out Makefile GNUmakefile, $^)
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
# The effect is to merely touch the POT file if it exists and would
# not change except for POT-Creation-Date; otherwise create it anew.
#
AC_DEFUN([StM_XGETTEXT_RULE],[{ :
   AC_REQUIRE([StM_PROG_XGETTEXT])

   if test -z "${XGETTEXT}"; then
      AC_MSG_ERROR([xgettext from GNU gettext is required.
           Consider installing GNU gettext.
           GNU gettext homepage: <https://www.gnu.org/software/gettext/>])
   fi

   # Update the POT file only if it has changed. Otherwise
   # `make distcheck' will fail, from the attempt to write
   # into the $(srcdir).
   AC_SUBST([$1],
      m4_flatten(["\
\@S|@(strip \@S|@1): \@S|@2 \@S|@4; \
	@(echo \"Running \@S|@\@S|@(XGETTEXT) -o \@S|@\@S|@(notdir \@S|@\@S|@@)-tmp \@S|@3 --force-po \@S|@\@S|@(filter-out \@S|@4, \@S|@\@S|@^)\" || :) && \
	\@S|@\@S|@(XGETTEXT) -o \@S|@\@S|@(notdir \@S|@\@S|@@)-tmp \@S|@3 --force-po \@S|@\@S|@(filter-out \@S|@4, \@S|@\@S|@^) && \
	if test -f '\@S|@\@S|@@'; then \
		\@S|@\@S|@(SED) -e '/^\"POT-Creation-Date:/{d;q}' '\@S|@\@S|@@' > '\@S|@\@S|@(notdir \@S|@\@S|@@)-datelesstmp' && \
		\@S|@\@S|@(SED) -e '/^\"POT-Creation-Date:/{d;q}' '\@S|@\@S|@(notdir \@S|@\@S|@@)-tmp' > '\@S|@\@S|@(notdir \@S|@\@S|@@)-tmp-datelesstmp' && \
		if cmp '\@S|@\@S|@(notdir \@S|@\@S|@@)-datelesstmp' '\@S|@\@S|@(notdir \@S|@\@S|@@)-tmp-datelesstmp' 2> /dev/null > /dev/null; then \
			(echo \"*** Strings unchanged: touch '\@S|@\@S|@@'\" || :) && \
			touch '\@S|@\@S|@@'; \
		else \
			(echo \"*** Strings changed: mv '\@S|@\@S|@(notdir \@S|@\@S|@@)-tmp' '\@S|@\@S|@@'\" || :) && \
			mv '\@S|@\@S|@(notdir \@S|@\@S|@@)-tmp' '\@S|@\@S|@@'; \
		fi; \
	else \
		(echo \"*** Creating POT file: mv '\@S|@\@S|@(notdir \@S|@\@S|@@)-tmp' '\@S|@\@S|@@'\" || :) && \
		mv '\@S|@\@S|@(notdir \@S|@\@S|@@)-tmp' '\@S|@\@S|@@'; \
	fi; \
	rm -f '\@S|@\@S|@(notdir \@S|@\@S|@@)-tmp' '\@S|@\@S|@(notdir \@S|@\@S|@@)-tmp-datelesstmp' '\@S|@\@S|@(notdir \@S|@\@S|@@)-datelesstmp'"]))
}])
