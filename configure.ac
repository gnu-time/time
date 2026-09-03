# -*- autoconf -*-
# Process this file with autoconf to produce a configure script.

# Copyright (C) 1990-2021, 2026 Free Software Foundation, Inc.

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

dnl Minimum Autoconf version required.
AC_PREREQ([2.69])

AC_INIT([GNU Time],
        m4_esyscmd([build-aux/git-version-gen .tarball-version]),
        [bug-time@gnu.org],
        [time],
        [https://www.gnu.org/software/time/])

AC_CONFIG_SRCDIR([src/time.c])

dnl Must come before AM_INIT_AUTOMAKE.
AC_CONFIG_AUX_DIR([build-aux])

dnl Where to generate output; srcdir location.
AC_CONFIG_HEADERS([config.h:config.in])

AM_INIT_AUTOMAKE([1.11.2 dist-xz color-tests parallel-tests subdir-objects])
AM_SILENT_RULES([yes])

dnl Checks for programs.
AC_USE_SYSTEM_EXTENSIONS
AC_PROG_CC
AM_PROG_CC_C_O
AC_PROG_CPP
AC_PROG_INSTALL
AC_C_INLINE

# Since we use gnulib: gl_EARLY must be called as soon as possible after
# the C compiler is checked.  The others could be later, but we just
# keep everything together.
gl_EARLY
gl_INIT

AC_DEFINE([GNULIB_NO_VLA], [1], [Define to 1 to disable use of VLAs])

# gl_GCC_VERSION_IFELSE([major], [minor], [run-if-found], [run-if-not-found])
# ------------------------------------------------
# If $CPP is gcc-MAJOR.MINOR or newer, then run RUN-IF-FOUND.
# Otherwise, run RUN-IF-NOT-FOUND.
AC_DEFUN([gl_GCC_VERSION_IFELSE],
  [AC_PREPROC_IFELSE(
    [AC_LANG_PROGRAM(
      [[
#if ($1) < __GNUC__ || (($1) == __GNUC__ && ($2) <= __GNUC_MINOR__)
/* ok */
#else
# error "your version of gcc is older than $1.$2"
#endif
      ]]),
    ], [$3], [$4])
  ]
)

AC_ARG_ENABLE([gcc-warnings],
  [AS_HELP_STRING([--enable-gcc-warnings@<:@=TYPE@:>@],
    [control generation of GCC warnings.  The TYPE 'no' disables
     warnings (default for non-developer builds); 'yes' generates
     cheap warnings if available (default for developer builds);
     'expensive' in addition generates expensive-to-compute warnings
     if available.])],
  [case $enableval in
     no|yes|expensive) ;;
     *)      AC_MSG_ERROR([bad value $enableval for gcc-warnings option]) ;;
   esac
   gl_gcc_warnings=$enableval],
  [
   # GCC provides fine-grained control over diagnostics which
   # is used in gnulib for example to suppress warnings from
   # certain sections of code.  So if this is available and
   # we're running from a git repo, then auto enable the warnings.
   gl_gcc_warnings=no
   gl_GCC_VERSION_IFELSE([4], [6],
                         [test -d "$srcdir"/.git \
                          && ! test -f "$srcdir"/.tarball-version \
                          && gl_gcc_warnings=yes])]
)

# clang is unduly picky about some things, even by default.
if test "$gl_cv_compiler_clang" = yes; then
  gl_WARN_ADD([-Wno-format-extra-args])
  gl_WARN_ADD([-Wno-implicit-const-int-float-conversion])
  gl_WARN_ADD([-Wno-tautological-constant-out-of-range-compare])
fi

if test $gl_gcc_warnings != no; then
  gl_WARN_ADD([-Werror], [WERROR_CFLAGS])
  AC_SUBST([WERROR_CFLAGS])

  ew=
  AS_IF([test $gl_gcc_warnings != expensive],
    [# -fanalyzer and related options slow GCC considerably.
     ew="$ew -fanalyzer -Wno-analyzer-malloc-leak"])

  # This, $nw, is the list of warnings we disable.
  nw=$ew
  nw="$nw -Wstack-protector"        # not worth working around for pre GCC 15
  nw="$nw -Wformat-overflow=2"      # False alarms due to GCC bug 110333
  nw="$nw -Wformat-truncation=2"    # False alarm in ls.c, probably related
  nw="$nw -Winline"                 # system.h's readdir_ignoring_dot_and_dotdot

  # Using -Wstrict-overflow is a pain, but the alternative is worse.
  # For an example, see the code that provoked this report:
  # https://gcc.gnu.org/PR33498
  # Code like that still infloops with gcc-4.6.0 and -O2.  Scary indeed.

  gl_MANYWARN_ALL_GCC([ws])
  AS_VAR_APPEND([ws], [' -Wswitch-enum'])
  AS_VAR_APPEND([ws], [' -Wtrailing-whitespace'])
  gl_MANYWARN_COMPLEMENT([ws], [$ws], [$nw])
  for w in $ws; do
    gl_WARN_ADD([$w])
  done
  gl_WARN_ADD([-Wno-sign-compare])     # Too many warnings for now
  gl_WARN_ADD([-Wno-format-nonliteral])

  AC_SUBST([WARN_CFLAGS])

  AC_DEFINE([lint], [1], [Define to 1 if the compiler is checking for lint.])
  AH_VERBATIM([FORTIFY_SOURCE],
  [/* Enable compile-time and run-time bounds-checking, and some warnings,
      without upsetting glibc 2.15+. */
   #if !defined _FORTIFY_SOURCE && defined __OPTIMIZE__ && __OPTIMIZE__
   # define _FORTIFY_SOURCE 2
   #endif
])
  AC_DEFINE([GNULIB_PORTCHECK], [1], [enable some gnulib portability checks])

  # We use a slightly smaller set of warning options for lib/.
  # Remove the following and save the result in GNULIB_WARN_CFLAGS.
  nw=$ew
  nw="$nw -Wduplicated-branches"    # Too many false alarms
  nw="$nw -Wformat-truncation=2"
  nw="$nw -Wunused-macros"

  gl_MANYWARN_COMPLEMENT([GNULIB_WARN_CFLAGS], [$WARN_CFLAGS], [$nw])
  AC_SUBST([GNULIB_WARN_CFLAGS])

  # For gnulib-tests, the set is slightly smaller still.
  nw=
  # It's not worth being this picky about test programs.
  nw="$nw -Wmissing-variable-declarations"
  nw="$nw -Wsuggest-attribute=cold"
  nw="$nw -Wsuggest-attribute=const"
  nw="$nw -Wsuggest-attribute=format"
  nw="$nw -Wsuggest-attribute=pure"
  gl_MANYWARN_COMPLEMENT([GNULIB_TEST_WARN_CFLAGS],
                         [$GNULIB_WARN_CFLAGS], [$nw])
  AC_SUBST([GNULIB_TEST_WARN_CFLAGS])
fi

dnl Checks for header files.
AC_CHECK_INCLUDES_DEFAULT
AC_PROG_EGREP

AC_HEADER_SYS_WAIT

dnl Checks for typedefs, structures, and compiler characteristics.
AC_C_CONST
AC_TYPE_PID_T
AC_TYPE_SIZE_T

dnl Checks for library functions.
AC_FUNC_VPRINTF
AC_CHECK_FUNCS(strerror)


# What memory units are reported by getrusage(2) ?
warn_getrusage_mem_units=
if test -z "$time_getrusage_mem_units" ; then
  # if envvar 'time_getrusage_mem_units' isn't set,
  # autodetect based on OS.
  case "$host_os" in
    minix*|aix*|*bsd*|dragonfly*|linux*|gnu*|haiku*)
                     time_getrusage_mem_units=kb ;;

    macos*|darwin*)  time_getrusage_mem_units=bytes ;;

    solaris*)        time_getrusage_mem_units=pages ;;

    # As a fallback, assume KB (the most common value).
    # Set the 'warn' variable to warn the user at the end
    # of ./configure
    *) time_getrusage_mem_units=kb
       warn_getrusage_mem_units=yes
       ;;
  esac
fi

# Define the configuration item
case $time_getrusage_mem_units in
  kb)
     AC_DEFINE([GETRUSAGE_RETURNS_KB],[1],
                [Define to 1 if getrusage(2) on this systems returns
                 ru_maxrss in kilobytes or sets it to zero])
     ;;

  bytes)
     AC_DEFINE([GETRUSAGE_RETURNS_BYTES],[1],
               [Define to 1 if getrusage(2) on this systems returns
                ru_maxrss in bytes])
     ;;

  pages)
     AC_DEFINE([GETRUSAGE_RETURNS_PAGES],[1],
               [Define to 1 if getrusage(2) on this systems returns
                ru_maxrss in pages])
     ;;

  *) # should never happen
     AC_MSG_ERROR([invalid 'time_getrusage_mem_units' value
                   '$time_getrusage_mem_units'])
     ;;
esac


# This is needed when building outside the source dir
# with --disable-dependency-tracking.
# Inspired by sed's https://bugs.gnu.org/25371
AS_MKDIR_P([lib])
AS_MKDIR_P([src])
AS_MKDIR_P([doc])
AS_MKDIR_P([tests])

AM_GNU_GETTEXT([external])
AM_GNU_GETTEXT_VERSION([0.19.2])

AC_CONFIG_FILES([Makefile po/Makefile.in])
AC_OUTPUT

# Warn the user if getrusage(2) behaviour on this OS is unknown
if test "$warn_getrusage_mem_units" ; then
  AC_MSG_WARN([unknown getrusage behavior on operating system '$host_os'.
               Assuming Kilobytes.
               please report this with the output of 'uname -a' to
               bug-time@gnu.org])
fi
