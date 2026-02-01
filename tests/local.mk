# Run times tests.					-*-Makefile-*-
# This is included by the top-level Makefile.am.

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

# Indirection required so that we'll still be able to know the
# complete list of our tests even if the user overrides TESTS
# from the command line (as permitted by the test harness API).
TESTS = $(all_tests)

EXTRA_DIST += $(all_tests) tests/init.sh

TEST_EXTENSIONS = .sh

# We don't want this to go in the top-level directory.
TEST_SUITE_LOG = tests/test-suite.log

# Display the testsuite log to standard output on failure.
VERBOSE = yes

# Build the auxiliary program used for testing 'time'.
# This program is kept minimal and POSIX-compatible on purpose,
# and does not need gnulib's headers/modules.
# (thus, override the global AM_CPPFLAGS/AM_CFLAGS/LDADD)
check_PROGRAMS = tests/time-aux
tests_time_aux_SOURCES = tests/time-aux.c
tests_time_aux_CPPFLAGS =
tests_time_aux_CFLAGS =
tests_time_aux_LDADD =

all_tests =				\
  tests/help-version.sh			\
  tests/time-max-rss.sh			\
  tests/time-child-stderr.sh		\
  tests/time-environment.sh		\
  tests/time-exit-codes.sh		\
  tests/time-posix-quiet.sh		\
  tests/time-trailing-backslash.sh	\
  tests/time-verbose.sh			\
  tests/time-format-T.sh

# Note: the "9>&2" redirection is part of Automake's parallel-tests.
#       see also stderr_fileno in 'init.cfg'
TESTS_ENVIRONMENT = \
  top_srcdir=$(abs_top_srcdir) \
  srcdir='$(srcdir)' \
  PATH='$(abs_top_builddir)$(PATH_SEPARATOR)$(abs_top_builddir)/tests$(PATH_SEPARATOR)'$$PATH \
  LC_ALL=C \
  VERSION='$(VERSION)' \
  test_dir='$(abs_top_srcdir)/tests' ; \
  export top_srcdir PATH LC_ALL VERSION srcdir; \
  9>&2
