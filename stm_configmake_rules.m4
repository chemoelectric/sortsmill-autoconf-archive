# -*- autoconf -*-
#
# Copyright (C) 2013 Khaled Hosny and Barry Schwartz
# 
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# serial 4

AC_DEFUN([stm__configmake_rule],
   [m4_ifblank([$3],
      [m4_if([$1], [scm],
         ["\$(call configmake_[$1]_rule,\$(1),\$(2),[$2],\$(3),\$(4),\$(5))"],
         ["\$(call configmake_[$1]_rule,\$(1),[$2],\$(2),\$(3),\$(4))"])],
      [m4_if([$1], [scm],
         ["\$(if \$(strip \$([$3])),\$(call configmake_[$1]_rule,\$(1),\$(2),[$2],\$(3),[$3] \$(4),\$(5)),\$(call configmake_[$1]_rule,\$(1),\$(2),[$2],\$(3),\$(4),\$(5)))"],
         ["\$(if \$(strip \$([$3])),\$(call configmake_[$1]_rule,\$(1),[$2],\$(2),[$3] \$(3),\$(4)),\$(call configmake_[$1]_rule,\$(1),[$2],\$(2),\$(3),\$(4)))"])])])

AC_DEFUN([stm__pkginfo_configmake_rule],
   [stm__configmake_rule([$1],
                         m4_escape(AS_ESCAPE([Package information for $(PACKAGE_NAME).])),
                         [PKGINFO_LIST])])

AC_DEFUN([stm__dirlayout_configmake_rule],
   [stm__configmake_rule([$1],
                         m4_escape(AS_ESCAPE([Directory layout of $(PACKAGE_NAME).])),
                         [DIRLAYOUT_LIST])])

AC_DEFUN([stm__confopts_configmake_rule],
   [stm__configmake_rule([$1],
                         m4_escape(AS_ESCAPE([Configuration options that were chosen for $(PACKAGE_NAME).])),
                         [CONFOPTS_LIST])])

# StM_CONFIGMAKE_RULES
# --------------------
#
# FIXME: Document this.
#
AC_DEFUN([StM_CONFIGMAKE_RULES], [if true; then

   m4_pattern_allow([AM_V_GEN])

   AC_REQUIRE([StM_CONFIGMAKE_DEFINES])

   AC_SUBST([configmake_h_rule],
      ["\$(strip \$(1)): ; \
          \$\$(AM_V_GEN)( set -e; \
            \$\$(MKDIR_P) \$\$(@D); \
            { \
              echo '/* \$(2) */'; \
              echo; \
              \$(if \$(strip \$(4)\$(5)),:,echo '/* This header file has nothing in it. */'); \
              \$(if \$(strip \$(4)),\$(call configmake_c_defines, \$(3), \$(4));) \
              \$(if \$(strip \$(4)),\$(call configmake_c_defines_utf8, \$(3), \$(4), _IN_UTF8);) \
              \$(if \$(strip \$(5)),\$(call configmake_c_defines_unquoted, \$(3), \$(5));) \
            } > \$\$(@)-tmp; \
            mv \$\$(@)-tmp \$\$(@) )"])

   AC_SUBST([configmake_m4_rule],
      ["\$(strip \$(1)): ; \
       \$\$(AM_V_GEN)( set -e; \
         \$\$(MKDIR_P) \$\$(@D); \
         { \
           echo 'd''nl  \$(2)'; \
           echo 'd''nl'; \
           \$(if \$(strip \$(4)\$(5)),:,echo 'd''nl  This m4 file has nothing in it.'); \
           \$(if \$(strip \$(4)\$(5)),\$(call configmake_m4sugar_defines, \$(3), \$(4) \$(5));) \
         } > \$\$(@)-tmp; \
         mv \$\$(@)-tmp \$\$(@) )"])

   AC_SUBST([configmake_scm_rule],
      ["\$(strip \$(1)): ; \
          \$\$(AM_V_GEN)( set -e; \
            \$\$(MKDIR_P) \$\$(@D); \
            { \
              echo ';; \$(3)  -*- coding: utf-8 -*-'; \
              echo; \
		      echo '(library (\$(strip \$(2)))'; \
              echo; \
        	  echo '(export \$\$(addprefix \$(4),\$\$(strip \$(shell echo \$(5) \$(6) | LC_ALL=C tr \"[[a-z]]\" \"[[A-Z]]\"))))'; \
              echo; \
              echo '(import (rnrs base))'; \
              echo; \
              \$(if \$(strip \$(5)\$(6)),:,echo ';;;';echo ';;; This library has nothing in it.';echo ';;;';echo); \
              \$(if \$(strip \$(5)),\$(call configmake_scheme_defines, \$(4), \$(5));) \
              \$(if \$(strip \$(6)),\$(call configmake_scheme_defines_unquoted, \$(4), \$(6));) \
              echo ')'; \
            } > \$\$(@)-tmp; \
            mv \$\$(@)-tmp \$\$(@) )"])

   AC_SUBST([pkginfo_h_rule], [stm__pkginfo_configmake_rule([h])])
   AC_SUBST([pkginfo_m4_rule], [stm__pkginfo_configmake_rule([m4])])
   AC_SUBST([pkginfo_scm_rule], [stm__pkginfo_configmake_rule([scm])])

   AC_SUBST([dirlayout_h_rule], [stm__dirlayout_configmake_rule([h])])
   AC_SUBST([dirlayout_m4_rule], [stm__dirlayout_configmake_rule([m4])])
   AC_SUBST([dirlayout_scm_rule], [stm__dirlayout_configmake_rule([scm])])

   AC_SUBST([confopts_h_rule], [stm__confopts_configmake_rule([h])])
   AC_SUBST([confopts_m4_rule], [stm__confopts_configmake_rule([m4])])
   AC_SUBST([confopts_scm_rule], [stm__confopts_configmake_rule([scm])])

   AC_SUBST([configmake_vars_list],
      ["AS_ESCAPE([$(strip $(join $(patsubst %,@<:@@<:@%@:>@$(stm__configmake_comma),$(2)),$(patsubst %,@<:@$(strip $(1))%$(strip $(3))@:>@@:>@,$(shell echo $(2) | LC_ALL=C tr '[[a-z]]' '[[A-Z]]'))))])"])

   dnl  FIXME: We could benefit from an Autoconf module
   dnl         to define useful constructs of this kind.
   dnl         WRITE IT! But be careful what we put in it.
   AC_SUBST([stm__configmake_comma], [","])

fi])
