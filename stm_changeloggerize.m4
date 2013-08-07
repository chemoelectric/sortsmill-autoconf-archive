# -*- autoconf -*-
#
# Copyright (C) 2013 Khaled Hosny and Barry Schwartz
# 
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# serial 2

# StM_CHANGELOGGERIZE([changelogging_rules_var = `dist_changelog_rules'],
#                     [make_target = `dist-changelog'],
#                     [changelog = `$(distdir)/ChangeLog'])
# -----------------------------------------------------------------------
#
# Typical use:
#
#    In configure.ac:
#
#          StM_CHANGELOGGERIZE
#
#    In Makefile.am:
#
#          dist-hook: dist-changelog
#          @dist_changelog_rules@
#
# StM_CHANGELOGGERIZE calls StM_PROG_SORTSMILL_CHANGELOGGER; thus
# there is no need to call that separately.
#
AC_DEFUN([StM_CHANGELOGGERIZE],[
   AC_REQUIRE([StM_PROG_SORTSMILL_CHANGELOGGER])
dnl AM_SUBST_NOTMAKE requires Automake >= 1.11.
   AM_SUBST_NOTMAKE(m4_quote(m4_ifval([$1],[$1],[dist_changelog_rules])))
   AC_SUBST(m4_quote(m4_ifval([$1],[$1],[dist_changelog_rules])),["

.PHONY: m4_ifval([$2],[$2],[dist-changelog])

# @code{make distcheck} constructs the source package twice; the
# second time, at least, no VCS repo will be present, and so the
# message below will be echoed. The ChangeLog you actually get,
# however, should be the same as what you would get from
# @code{make dist}.
m4_ifval([$2],[$2],[dist-changelog]):
	@if \@S|@(SORTSMILL_CHANGELOGGER) false -C \@S|@(top_srcdir) > ChangeLog-tmp; then \
		mv -f ChangeLog-tmp m4_ifval([$3],[$3],[\@S|@(distdir)/ChangeLog]); \
	else \
		rm -f ChangeLog-tmp; \
		echo \"*WARNING*:\"; \
		echo \"*WARNING*:  I did not automatically remake m4_ifval([$3],[$3],[\@S|@(distdir)/ChangeLog])\"; \
		echo \"*WARNING*:  because the sources are not in a compatible VCS repository,\"; \
		echo \"*WARNING*:  or because I could not run sortsmill-changelogger.\"; \
		echo \"*WARNING*:  If you are using non-VCS sources, the existing file will be kept.\"; \
		echo \"*WARNING*:\"; \
		echo \"*WARNING*:  (Note: If this make recipe is run via \\\`dist-hook:',\"; \
		echo \"*WARNING*:  then, during a \\\`make distcheck',\"; \
		echo \"*WARNING*:  this message should appear at some point.)\"; \
		echo \"*WARNING*:\"; \
	fi

"])
])
