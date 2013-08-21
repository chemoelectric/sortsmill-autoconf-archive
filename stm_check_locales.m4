# -*- autoconf -*-
#
# Copyright (C) 2013 Khaled Hosny and Barry Schwartz
# 
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# serial 1

# StM_CHECK_LOCALES(checking_message, cache_variable, locale1 locale2 ..., [codeset1 codeset2 ...], [count_limit])
# ----------------------------------------------------------------------------------------------------------------
#
# Check the availability of the given locales, optionally subject to
# the constraint that the character encoding for the locale be among
# those listed. Assign a whitespace-separated list of the available
# locales (optionally up to the given `count_limit' number of them) to
# the given cache variable.
#
# Using checking_message as the message printed by AC_CACHE_CHECK.
#
# Example:
#
# StM_CHECK_LOCALES([for any one UTF-8 locale],
#                   [my_cv_utf8_locale],
#                   [eo_EO eo_EO.UTF-8 fr_FR fr_FR.UTF-8, en_US en_US.UTF-8],
#                   [UTF-8],
#                   [1])
#
AC_DEFUN([StM_CHECK_LOCALES],[{ :;
   AC_CACHE_CHECK(AS_ESCAPE([$1]),[$2],[
      AC_LANG_PUSH([C])

      AC_LINK_IFELSE([
         AC_LANG_PROGRAM([
@%:@include <stdio.h>
@%:@include <string.h>
@%:@include <limits.h>
@%:@include <locale.h>
m4_ifval([$4],[@%:@include <langinfo.h>])

char *locales@<:@@:>@ = {
  m4_foreach_w(__locale,[$3],["__locale",
])
  NULL
};
         ],[
  char *result;
  int i;
  int count;
  int max_count;
  int found;

  m4_ifval([$5],[max_count = $5;],[max_count = INT_MAX;])
  count = 0;
  i = 0;
  while (count < max_count && locales@<:@i@:>@ != NULL)
    {
      result = (count < max_count) ? setlocale (LC_ALL, locales@<:@i@:>@) : NULL;
      if (result != NULL)
        {
          m4_ifval([$4],[
          found = 0;
          m4_foreach_w(__codeset,[$4],[
          if (!found && strcmp ("$4", nl_langinfo (CODESET)) == 0)
            found = 1;
          ])dnl m4_foreach_w
          ],[
          found = 1;
          ])dnl m4_ifval

          if (found)
            {
              printf ("%s ", result);
              count++;
            }
        }
      i++;
    }
         ])dnl AC_LANG_PROGRAM
      ],
      [$2=`./conftest${EXEEXT} || :`],
      [$2=])dnl AC_LINK_IFELSE

      AC_LANG_POP
   ])
# END AC_CACHE_CHECK
}])
