# Make time.						-*-Makefile-*-

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

EXTRA_DIST =		\
  .prev-version		\
  .version		\
  ChangeLog-2015

ACLOCAL_AMFLAGS = -I m4

AM_CPPFLAGS = \
	-Ilib -I$(top_srcdir)/lib -I$(top_builddir)/lib \
	-Isrc -I$(top_srcdir)/src

##
## These must be set before including gnulib
##
CLEANFILES =
MOSTLYCLEANFILES =
MOSTLYCLEANDIRS =
MAINTAINERCLEANFILES =
noinst_LIBRARIES =
BUILT_SOURCES =


##
## gnulib as library, when used in non-recursive makefile
##
include lib/gnulib.mk

lib_libtime_a_CPPFLAGS = $(AM_CPPFLAGS) -I$(top_srcdir)/lib/ \
			-I$(top_builddir)/lib
lib_libtime_a_CFLAGS = $(AM_CFLAGS) $(GNULIB_WARN_CFLAGS) $(WERROR_CFLAGS)

#TODO: add '$(ALLOCA)' ??
lib_libtime_a_LIBADD += $(LIBOBJS)
lib_libtime_a_DEPENDENCIES += $(LIBOBJS)

noinst_LIBRARIES += src/libver.a
nodist_src_libver_a_SOURCES = src/version.c src/version.h

##
## GNU Time
##
bin_PROGRAMS = time

time_SOURCES = \
	src/time.c \
	src/resuse.c src/resuse.h \
	src/rusage-kb.h src/rusage-kb.c

time_CFLAGS = $(WARN_CFLAGS)

time_LDADD = \
       src/libver.a lib/lib$(PACKAGE).a

#SUBDIRS = . gnulib-tests

EXTRA_DIST += \
	m4/gnulib-cache.m4

DISTCLEANFILES =

BUILT_SOURCES += src/version.c
src/version.c: Makefile
	$(AM_V_GEN)rm -f $@
	$(AM_V_at)${MKDIR_P} src
	$(AM_V_at)printf '#include <config.h>\n' > $@t
	$(AM_V_at)printf '#include "version.h"\n' >> $@t
	$(AM_V_at)printf 'char const *Version = "$(PACKAGE_VERSION)";\n' >> $@t
	$(AM_V_at)chmod a-w $@t
	$(AM_V_at)mv $@t $@

BUILT_SOURCES += src/version.h
src/version.h: Makefile
	$(AM_V_GEN)rm -f $@
	$(AM_V_at)${MKDIR_P} src
	$(AM_V_at)printf 'extern char const *Version;\n' > $@t
	$(AM_V_at)chmod a-w $@t
	$(AM_V_at)mv $@t $@

DISTCLEANFILES += src/version.c src/version.h
MAINTAINERCLEANFILES += $(BUILT_SOURCES)

##
## Tests
##

# Build the auxiliary program used for testing 'time'.
# This program is kept minimal and POSIX-compatible on purpose,
# and does not need gnulib's headers/modules.
# (thus, override the global AM_CPPFLAGS/AM_CFLAGS)
check_PROGRAMS = tests/time-aux
tests_time_aux_SOURCES = tests/time-aux.c
tests_time_aux_CPPFLAGS =
tests_time_aux_CFLAGS =


TESTS = tests/help-version.sh \
	tests/time-max-rss.sh \
	tests/time-exit-codes.sh \
	tests/time-posix-quiet.sh \
	tests/time-format-T.sh

TEST_EXTENSIONS = .sh

EXTRA_DIST += tests/init.sh \
	$(TESTS)

# Note: the "9>&2" redirection is part of Automake's parallel-tests.
#       see also stderr_fileno in 'init.cfg'
TESTS_ENVIRONMENT = \
  top_srcdir=$(abs_top_srcdir) \
  PATH='$(abs_top_builddir)$(PATH_SEPARATOR)$(abs_top_builddir)/tests$(PATH_SEPARATOR)'$$PATH \
  LC_ALL=C \
  VERSION='$(VERSION)' \
  test_dir='$(abs_top_srcdir)/tests' ; \
  export top_srcdir PATH LC_ALL VERSION test_dir ; \
  9>&2

BUILT_SOURCES += .version
.version:
	$(AM_V_GEN)echo $(VERSION) > $@-t && mv $@-t $@

dist-hook: gen-ChangeLog
	$(AM_V_GEN)echo $(VERSION) > $(distdir)/.tarball-version

.PHONY: gen-ChangeLog
gen-ChangeLog:
	$(AM_V_GEN)if test -d .git; then				\
	  $(top_srcdir)/build-aux/gitlog-to-changelog			\
	  > $(distdir)/cl-t &&						\
	    { rm -f $(distdir)/ChangeLog &&				\
	      mv $(distdir)/cl-t $(distdir)/ChangeLog; }		\
	fi

include $(top_srcdir)/doc/local.mk
