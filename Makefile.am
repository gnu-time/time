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

SUBDIRS = po .

EXTRA_DIST =		\
  .prev-version		\
  .version		\
  ChangeLog-2015	\
  bootstrap		\
  bootstrap.conf	\
  cfg.mk		\
  maint.mk

ACLOCAL_AMFLAGS = -I m4

BUILT_SOURCES = .version
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

noinst_LIBRARIES =
MOSTLYCLEANFILES =
CLEANFILES =
DISTCLEANFILES =
MAINTAINERCLEANFILES =
MOSTLYCLEANDIRS =

AM_CPPFLAGS = -Ilib -I$(top_srcdir)/lib -Isrc -I$(top_srcdir)/src

include lib/gnulib.mk
include $(top_srcdir)/src/local.mk
include $(top_srcdir)/doc/local.mk
include $(top_srcdir)/tests/local.mk
