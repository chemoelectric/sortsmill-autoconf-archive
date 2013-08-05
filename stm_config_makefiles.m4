# -*- autoconf -*-
#
# Copyright (C) 2013 Khaled Hosny and Barry Schwartz
# 
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# serial 1

# StM_CONFIG_MAKEFILES([makefile = `Makefile'],
#                      [gnu_makefile = `GNUmakefile'],
#                      [gnu_make_command = `${_cv_gnu_make_command}'])
# --------------------------------------------------------------------
#
# Configure Makefile and GNUmakefile, making Makefile a wrapper around
# GNUmakefile, if GNU Make is present.
#
# Typical use is to call the Autoconf Archive macro AX_CHECK_GNU_MAKE
# sometime before calling StM_CONFIG_MAKEFILES:
#
#           .
#           .
#           .
#     AX_CHECK_GNU_MAKE
#           .
#           .
#           .
#     StM_CONFIG_MAKEFILES
#     StM_CONFIG_MAKEFILES([lib/Makefile],[lib/GNUmakefile])
#           .
#           .
#           .
#
AC_DEFUN([StM_CONFIG_MAKEFILES],[

   # If no GNU Make is found, recommend it.
   if test -z m4_ifval([$3],[$3],["${_cv_gnu_make_command}"]) \
         -a x"${__stm_config_makefiles_consider_gnu_make_printed}" != xyes; then
      AC_MSG_WARN([Please consider installing and using GNU Make:
           http://www.gnu.org/software/make/])
      __stm_config_makefiles_consider_gnu_make_printed=yes
   fi

   # Create `Makefile' or its substitute. If GNU Make is present,
   # create `Makefile' (or its substitute) as a wrapper around
   # `GNUmakefile' (or its substitute). Otherwise create the former in
   # the usual way.
   AC_CONFIG_FILES(m4_ifval([$1],[$1],[Makefile]),[
      # If GNU make is present, encourage other makes to call it instead.
      if test -n "${__stm_config_makefiles_make_command}"; then
         cat > m4_ifval([$1],[$1],[Makefile]) <<EOF
# Attempt to have common non-GNU Make programs run GNU Make.

.DEFAULT:
	m4_ifval([$3],[$3],[${__stm_config_makefiles_make_command}]) \@S|@@

%:
	m4_ifval([$3],[$3],[${__stm_config_makefiles_make_command}])
EOF
      fi
   ],
   [
      __stm_config_makefiles_make_command="${_cv_gnu_make_command}"
   ])

   # Create `GNUmakefile' or its substitute.
   AC_CONFIG_FILES(m4_ifval([$2],[$2],[GNUmakefile]):m4_ifval([$1],[$1],[Makefile]).in)
])
