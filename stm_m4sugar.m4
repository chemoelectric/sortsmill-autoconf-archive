# -*- autoconf -*-
#
# Copyright (C) 2013 Khaled Hosny and Barry Schwartz
# 
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# serial 1

# StM_M4SUGAR
# -----------
#
# Sets variables for using m4sugar in Automake scripts:
#
#    $(TRANSLATE_M4SUGAR_QUADRIGRAPHS) = filter to tranlate quadrigraphs (one pass only)
#
#    $(TRANSLATE_M4SUGAR) = filter to translate m4sugar;
#                           includes a pass through $(TRANSLATE_M4SUGAR_QUADRIGRAPHS)
#
#    $(AM_V_M4SUGAR) = one of those silent-rules helpers, for `M4SUGAR'
#
# Creates a GNU Make macro called `m4sugar_rule', where for instance
# 
#    $(call m4sugar_rule, %.c, %.c.m4)
#
# expands to the equivalent of
#
#    %.c: %.c.m4
#        $(AM_V_M4SUGAR)$(TRANSLATE_M4SUGAR) < '$$<' > '$$@-tmp'
#        mv '$$@-tmp' '$$@'
#
# StM_M4SUGAR requires and so creates a helper script called
# `quadrigraph-tool', putting it in $(top_builddir). Be sure to add it
# to DISTCLEANFILES.
#
AC_DEFUN([StM_M4SUGAR],[{ :
   AC_REQUIRE([AC_PROG_SED])
   AC_REQUIRE([StM_PROG_GNU_M4])

   AC_CONFIG_COMMANDS([quadrigraph-tool],[
      ${SED} -e 's/AT/@/g' > quadrigraph-tool <<EOF
@%:@! ${SED} -f
s/AT<:AT/@<:@/g
s/AT:>AT/@:>@/g
s/AT{:AT/@{:@/g
s/AT:}AT/@:}@/g
s/ATS|AT/@S|@/g
s/AT%:AT/@%:@/g
s/AT&tAT/@&t@/g
EOF
      chmod +x quadrigraph-tool
])

   AC_SUBST([TRANSLATE_M4SUGAR_QUADRIGRAPHS],
            ['$(SED) -f $(top_builddir)/quadrigraph-tool'])

   AC_SUBST([TRANSLATE_M4SUGAR],
            ['($(GNU_M4) $(M4SUGAR_FLAGS) | $(TRANSLATE_M4SUGAR_QUADRIGRAPHS))'])

   AC_SUBST([AM_V_M4SUGAR],['$(AM_V_M4SUGAR_$(V))'])
   AC_SUBST([AM_V_M4SUGAR_],['$(AM_V_M4SUGAR_$(AM_DEFAULT_VERBOSITY))'])
   AC_SUBST([AM_V_M4SUGAR_0],['@echo "  M4SUGAR " @S|@@;'])

   AC_SUBST([m4sugar_rule],
      ["\@S|@(1): \@S|@(2); \@S|@(AM_V_M4SUGAR)\@S|@(TRANSLATE_M4SUGAR) < '\@S|@\@S|@<' > '\@S|@\@S|@@-tmp'; mv '\@S|@\@S|@@-tmp' '\@S|@\@S|@@'"])
}])
