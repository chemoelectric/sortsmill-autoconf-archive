# -*- autoconf -*-
#
# Copyright (C) 2013 Khaled Hosny and Barry Schwartz
# 
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# serial 3

# Try to convert a space-and-comma-separated list into a normalized
# space-separated list. (If you are not forgiving of the list format,
# the resulting errors may be difficult to notice or diagnose because
# they result simply in failure to link the program, which we
# currently treat as `no results' rather than a configure-script
# error.)
#
# FIXME: Probably this macro can be improved.
m4_define([__stm_check_locales_prep_list],
          [m4_normalize(m4_translit(m4_dquote($1),[,],[ ]))])

# StM_DEFAULT_CHECK_LOCALES
# -------------------------
#
# A list of locales to try. Include Esperanto, in honor of Zamenhof,
# but last because it is not maintained as part of GNU. It is added
# by Debian, but add-ons are not to be preferred.
#
AC_DEFUN([StM_DEFAULT_CHECK_LOCALES],[C aa_DJ.UTF-8 aa_DJ
aa_ER aa_ER@saaho aa_ET af_ZA.UTF-8 af_ZA am_ET an_ES.UTF-8 an_ES
ar_AE.UTF-8 ar_AE ar_BH.UTF-8 ar_BH ar_DZ.UTF-8 ar_DZ ar_EG.UTF-8
ar_EG ar_IN ar_IQ.UTF-8 ar_IQ ar_JO.UTF-8 ar_JO ar_KW.UTF-8 ar_KW
ar_LB.UTF-8 ar_LB ar_LY.UTF-8 ar_LY ar_MA.UTF-8 ar_MA ar_OM.UTF-8
ar_OM ar_QA.UTF-8 ar_QA ar_SA.UTF-8 ar_SA ar_SD.UTF-8 ar_SD
ar_SY.UTF-8 ar_SY ar_TN.UTF-8 ar_TN ar_YE.UTF-8 ar_YE az_AZ as_IN
ast_ES.UTF-8 ast_ES be_BY.UTF-8 be_BY be_BY@latin bem_ZM ber_DZ ber_MA
bg_BG.UTF-8 bg_BG bn_BD bn_IN bo_CN bo_IN br_FR.UTF-8 br_FR br_FR@euro
bs_BA.UTF-8 bs_BA byn_ER ca_AD.UTF-8 ca_AD ca_ES.UTF-8 ca_ES
ca_ES@euro ca_FR.UTF-8 ca_FR ca_IT.UTF-8 ca_IT crh_UA cs_CZ.UTF-8
cs_CZ csb_PL cv_RU cy_GB.UTF-8 cy_GB da_DK.UTF-8 da_DK de_AT.UTF-8
de_AT de_AT@euro de_BE.UTF-8 de_BE de_BE@euro de_CH.UTF-8 de_CH
de_DE.UTF-8 de_DE de_DE@euro de_LU.UTF-8 de_LU de_LU@euro dv_MV dz_BT
el_GR.UTF-8 el_GR el_CY.UTF-8 el_CY en_AG en_AU.UTF-8 en_AU
en_BW.UTF-8 en_BW en_CA.UTF-8 en_CA en_DK.UTF-8 en_DK en_GB.UTF-8
en_GB en_HK.UTF-8 en_HK en_IE.UTF-8 en_IE en_IE@euro en_IN en_NG
en_NZ.UTF-8 en_NZ en_PH.UTF-8 en_PH en_SG.UTF-8 en_SG en_US.UTF-8
en_US en_ZA.UTF-8 en_ZA en_ZM en_ZW.UTF-8 en_ZW es_AR.UTF-8 es_AR
es_BO.UTF-8 es_BO es_CL.UTF-8 es_CL es_CO.UTF-8 es_CO es_CR.UTF-8
es_CR es_DO.UTF-8 es_DO es_EC.UTF-8 es_EC es_ES.UTF-8 es_ES es_ES@euro
es_GT.UTF-8 es_GT es_HN.UTF-8 es_HN es_MX.UTF-8 es_MX es_NI.UTF-8
es_NI es_PA.UTF-8 es_PA es_PE.UTF-8 es_PE es_PR.UTF-8 es_PR
es_PY.UTF-8 es_PY es_SV.UTF-8 es_SV es_US.UTF-8 es_US es_UY.UTF-8
es_UY es_VE.UTF-8 es_VE et_EE.UTF-8 et_EE et_EE.ISO-8859-15
eu_ES.UTF-8 eu_ES eu_ES@euro fa_IR ff_SN fi_FI.UTF-8 fi_FI fi_FI@euro
fil_PH fo_FO.UTF-8 fo_FO fr_BE.UTF-8 fr_BE fr_BE@euro fr_CA.UTF-8
fr_CA fr_CH.UTF-8 fr_CH fr_FR.UTF-8 fr_FR fr_FR@euro fr_LU.UTF-8 fr_LU
fr_LU@euro fur_IT fy_NL fy_DE ga_IE.UTF-8 ga_IE ga_IE@euro gd_GB.UTF-8
gd_GB gez_ER gez_ER@abegede gez_ET gez_ET@abegede gl_ES.UTF-8 gl_ES
gl_ES@euro gu_IN gv_GB.UTF-8 gv_GB ha_NG he_IL.UTF-8 he_IL hi_IN
hne_IN hr_HR.UTF-8 hr_HR hsb_DE hsb_DE.UTF-8 ht_HT hu_HU.UTF-8 hu_HU
hy_AM hy_AM.ARMSCII-8 id_ID.UTF-8 id_ID ig_NG ik_CA is_IS.UTF-8 is_IS
it_CH.UTF-8 it_CH it_IT.UTF-8 it_IT it_IT@euro iu_CA iw_IL.UTF-8 iw_IL
ja_JP.EUC-JP ja_JP.UTF-8 ka_GE.UTF-8 ka_GE kk_KZ.UTF-8 kk_KZ
kl_GL.UTF-8 kl_GL km_KH kn_IN ko_KR.EUC-KR ko_KR.UTF-8 kok_IN ks_IN
ks_IN@devanagari ku_TR.UTF-8 ku_TR kw_GB.UTF-8 kw_GB ky_KG lb_LU
lg_UG.UTF-8 lg_UG li_BE li_NL lij_IT lo_LA lt_LT.UTF-8 lt_LT
lv_LV.UTF-8 lv_LV mai_IN mg_MG.UTF-8 mg_MG mhr_RU mi_NZ.UTF-8 mi_NZ
mk_MK.UTF-8 mk_MK ml_IN mn_MN mr_IN ms_MY.UTF-8 ms_MY mt_MT.UTF-8
mt_MT my_MM nan_TW@latin nb_NO.UTF-8 nb_NO nds_DE nds_NL ne_NP nl_AW
nl_BE.UTF-8 nl_BE nl_BE@euro nl_NL.UTF-8 nl_NL nl_NL@euro nn_NO.UTF-8
nn_NO nr_ZA nso_ZA oc_FR.UTF-8 oc_FR om_ET om_KE.UTF-8 om_KE or_IN
os_RU pa_IN pa_PK pap_AN pl_PL.UTF-8 pl_PL ps_AF pt_BR.UTF-8 pt_BR
pt_PT.UTF-8 pt_PT pt_PT@euro ro_RO.UTF-8 ro_RO ru_RU.KOI8-R
ru_RU.UTF-8 ru_RU ru_UA.UTF-8 ru_UA rw_RW sa_IN sc_IT sd_IN
sd_IN@devanagari se_NO shs_CA si_LK sid_ET sk_SK.UTF-8 sk_SK
sl_SI.UTF-8 sl_SI so_DJ.UTF-8 so_DJ so_ET so_KE.UTF-8 so_KE
so_SO.UTF-8 so_SO sq_AL.UTF-8 sq_AL sq_MK sr_ME sr_RS sr_RS@latin
ss_ZA st_ZA.UTF-8 st_ZA sv_FI.UTF-8 sv_FI sv_FI@euro sv_SE.UTF-8 sv_SE
sw_KE sw_TZ ta_IN te_IN tg_TJ.UTF-8 tg_TJ th_TH.UTF-8 th_TH ti_ER
ti_ET tig_ER tk_TM tl_PH.UTF-8 tl_PH tn_ZA tr_CY.UTF-8 tr_CY
tr_TR.UTF-8 tr_TR ts_ZA tt_RU tt_RU@iqtelif ug_CN uk_UA.UTF-8 uk_UA
ur_PK uz_UZ uz_UZ@cyrillic ve_ZA vi_VN.TCVN vi_VN wa_BE wa_BE@euro
wa_BE.UTF-8 wae_CH wo_SN xh_ZA.UTF-8 xh_ZA yi_US.UTF-8 yi_US yo_NG
yue_HK zh_CN.GB18030 zh_CN.GBK zh_CN.UTF-8 zh_CN zh_HK.UTF-8 zh_HK
zh_SG.UTF-8 zh_SG.GBK zh_SG zh_TW.EUC-TW zh_TW.UTF-8 zh_TW zu_ZA.UTF-8
zu_ZA eo_EO eo_EO.UTF-8])

# StM_CHECK_LOCALES(checking_message, cache_variable, [locale1 locale2 ...], [codeset1 codeset2 ...], [count_limit])
# ------------------------------------------------------------------------------------------------------------------
#
# Check the availability of the given locales (or the locales in a
# default set), optionally subject to the constraint that the
# character encoding for the locale be among those listed. Assign a
# space-separated list of the available locales (optionally up to the
# given `count_limit' number of them) to the given cache variable.
# The list has no leading or trailing whitespace, and each separation
# consists just a single space character (ASCII #x20).
#
# Using checking_message as the message printed by AC_CACHE_CHECK.
#
# Example:
#
# StM_CHECK_LOCALES([for an arbitrary UTF-8 locale],
#                   [my_cv_locale_utf8],
#                   [eo_EO eo_EO.UTF-8 fr_FR fr_FR.UTF-8 en_US en_US.UTF-8],
#                   [UTF-8],
#                   [1])
#
AC_DEFUN([StM_CHECK_LOCALES],[{ :;
   AC_REQUIRE([AC_PROG_SED])
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
  m4_map_args_w(__stm_check_locales_prep_list(m4_ifval([$3],[[$3]],[StM_DEFAULT_CHECK_LOCALES])),
                ["],[",
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
      [$2=`(./conftest${EXEEXT} | @S|@{SED} 's/ @S|@//') || :`],
      [$2=])dnl AC_LINK_IFELSE

      AC_LANG_POP
   ])
# END AC_CACHE_CHECK
}])

# StM_ARBITRARY_CODESET_LOCALE(variable, codeset)
# -----------------------------------------------
#
# AC_SUBST the variable to an arbitrary locale having the given
# codeset, or to an empty string if no such locale is found.
#
# The result is cached as stm_cv_locale_arbitrary_<CODESET>
#
AC_DEFUN([StM_ARBITRARY_CODESET_LOCALE],[{ :;
   StM_CHECK_LOCALES([for an arbitrary locale with codeset m4_normalize([$2])],
                     [AS_TR_SH([stm_cv_locale_arbitrary_]m4_normalize([$2]))],
                     [],
                     m4_normalize([$2]),
                     [1])
   AC_SUBST([$1],["${AS_TR_SH([stm_cv_locale_arbitrary_]m4_normalize([$2]))}"])
}])


# StM_C_LOCALE(variable)
# ----------------------
#
# AC_SUBST the variable to the C/POSIX locale, or to an empty string
# if no such locale is found.
#
# The result is cached as stm_cv_locale_c.
#
AC_DEFUN([StM_C_LOCALE],[{ :;
   StM_CHECK_LOCALES([for the C locale],
                     [stm_cv_locale_c],
                     [C POSIX],
                     [],
                     [1])
   AC_SUBST([$1],["${stm_cv_locale_c}"])
}])
