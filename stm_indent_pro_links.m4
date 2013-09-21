# -*- autoconf -*-
#
# Copyright (C) 2013 Khaled Hosny and Barry Schwartz
# 
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# serial 4

# StM_INDENT_PRO_LINKS(dir1 dir2 ...)
# -----------------------------------
#
# Install .indent.pro files as symbolic links.
#
# FIXME: Document this macro more thoroughly.
#
AC_DEFUN([StM_INDENT_PRO_LINKS],[if true; then

   AC_SUBST([INDENT_PRO_DIRS], m4_flatten(['$1']))

   AC_CONFIG_COMMANDS([.indent.pro],[

      # Create links in the source directories, but without
      # overwriting any existing .indent.pro files or links.
      # Links are made to the .indent.pro of the top-level
      # source directory.
      for dir in ${INDENT_PRO_DIRS}; do
         if test -d "${ac_srcdir}/${dir}"; then
            if test -e "${ac_srcdir}/${dir}/.indent.pro"; then
               :
            else
               (cd "${ac_srcdir}/${dir}" && \
                  (${LN_S} "${ac_top_srcdir}"/.indent.pro .indent.pro || : )) \
                     > /dev/null 2> /dev/null
            fi
         fi
      done

      # Create links in the build directories, creating the
      # directories if necessary.
      #
      # FIXME: Currently these are absolute links, which is
      # is undesirable because that makes them unrelocatable.
      #
      if test "${ac_srcdir}" -ef "${ac_builddir}"; then
         :
      else
         for dir in ${INDENT_PRO_DIRS}; do
            test -d "${dir}" || AS_MKDIR_P(["${dir}"])
            rm -f "${ac_builddir}/${dir}/.indent.pro"
            (cd "${ac_builddir}/${dir}" && \
               (${LN_S} "${ac_abs_top_srcdir}/${dir}/.indent.pro" .indent.pro || : )) \
                  > /dev/null 2> /dev/null
         done
      fi
   ],[
      INDENT_PRO_DIRS="${INDENT_PRO_DIRS}"
   ])

   # Provide for cleanup of links in the build directories.
   #
   # Put something like this in the top-level Makefile.am:
   #
   #    distclean-local: clean-indent-pro-files
   #    @indent_pro_files_rules@
   #
   indent_pro_files_rules='

clean-indent-pro-files:
	if test "@S|@(top_srcdir)" -ef "@S|@(top_builddir)"; then \
		:; \
	else \
		for dir in @S|@(INDENT_PRO_DIRS); do \
			rm -f "@S|@(top_builddir)/@S|@@S|@{dir}/.indent.pro"; \
		done; \
	fi

'
   AC_SUBST([indent_pro_files_rules],["${indent_pro_files_rules}"])
   AM_SUBST_NOTMAKE([indent_pro_files_rules])
fi])
