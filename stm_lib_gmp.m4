# -*- autoconf -*-
#
# Copyright (C) 2013 Khaled Hosny and Barry Schwartz
# 
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# serial 1

# StM_LIB_GMP
# -----------
#
# Check for libgmp, using AC_LIB_HAVE_LINKFLAGS (from Gnulib). Modify
# CPPFLAGS if appropriate, and AC_SUBST HAVE_LIBGMP, LIBGMP, and
# LTLIBGMP.
#
AC_DEFUN([StM_LIB_GMP],[if :
then
   AC_LIB_HAVE_LINKFLAGS([gmp], [],
      [@%:@include <gmp.h>],
      [mpz_t n;
       mpz_init_set_str (n, "1234", 0);
       mpz_mul (n, n, n);
       mpz_clear (n);])
fi])
