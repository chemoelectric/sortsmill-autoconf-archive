# -*- tab-width: 4 -*-

# Copyright (C) 2013 Khaled Hosny and Barry Schwartz
# This file is part of the Sorts Mill Autoconf Archive
# 
# Sorts Mill Autoconf Archive is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
# 
# Sorts Mill Autoconf Archive is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, see <http://www.gnu.org/licenses/>.

ACLOCAL_AMFLAGS = -I .

aclocaldir = $(datadir)/aclocal

dist_aclocal_DATA =

dist_aclocal_DATA += stm_analyze_package_version.m4
dist_aclocal_DATA += stm_changeloggerize.m4
dist_aclocal_DATA += stm_config_makefiles.m4
dist_aclocal_DATA += stm_make_readme.m4

dist_aclocal_DATA += stm_path_progs_cached_and_precious.m4

dist_aclocal_DATA += stm_prog_gawk.m4
dist_aclocal_DATA += stm_prog_gnu_indent.m4
dist_aclocal_DATA += stm_prog_help2man.m4
dist_aclocal_DATA += stm_prog_perl.m4
dist_aclocal_DATA += stm_prog_sortsmill_changelogger.m4
dist_aclocal_DATA += stm_prog_wget.m4

dist-hook: dist-changelog
@dist_changelog_rules@
