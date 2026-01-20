# Make time.						-*-Makefile-*-
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

AM_CFLAGS = $(WERROR_CFLAGS)

noinst_LIBRARIES += src/libver.a
nodist_src_libver_a_SOURCES = src/version.c src/version.h

bin_PROGRAMS = src/time

src_time_SOURCES =	\
  src/time.c		\
  src/resuse.c		\
  src/resuse.h		\
  src/rusage-kb.h	\
  src/rusage-kb.c

LDADD = src/libver.a lib/lib$(PACKAGE).a

src_time_LDADD = $(LDADD)

# For gettime.
src_time_LDADD += $(CLOCK_TIME_LIB)

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
