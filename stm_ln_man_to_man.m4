# -*- autoconf -*-
#
# Copyright (C) 2013 Khaled Hosny and Barry Schwartz
# 
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# serial 1

# StM_LN_MAN_TO_MAN
# -----------------
#
# AC_SUBST a GNU Make macro called `ln_man_to_man', that creates a
# rule to link one manpage to one or more equivalent manpages, by the
# .so method.
#
# Usage of the macro:
#
#    # <-- Start at the leftmost column.
#    $(call ln_man_to_man, common/path/prefix, \
#        manN/manpage_a.N, manN/manpage_b.N manN/manpage_c.N ..., \
#        [extra_dependency1 extra_dependency2 ...])
#
AC_DEFUN([StM_LN_MAN_TO_MAN],[
   AC_SUBST([ln_man_to_man],
      ["\@S|@(addprefix \@S|@(1)/, \@S|@(3)): \@S|@(addprefix \@S|@(1)/, \@S|@(2)) \@S|@(4); echo '.so \@S|@(2)' > \@S|@\@S|@@"])
])
