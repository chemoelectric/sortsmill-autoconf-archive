# -*- autoconf -*-
#
# Copyright (C) 2013 Khaled Hosny and Barry Schwartz
# 
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# serial 1

# StM_LIB_LIBJPEG
# ---------------
#
# Check for libjpeg, using AC_LIB_HAVE_LINKFLAGS from Gnulib.
#
AC_DEFUN([StM_LIB_LIBJPEG],[{ :
   AC_LIB_HAVE_LINKFLAGS([jpeg], [], [
@%:@include <stdio.h>
@%:@include <jpeglib.h>
   ],[
struct jpeg_decompress_struct cinfo;
jpeg_create_decompress (&cinfo);
   ])
}])
