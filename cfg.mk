# Customize maint.mk                           -*- makefile -*-
# Copyright (C) 2018-2021, 2026 Free Software Foundation, Inc.

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Used in maint.mk's web-manual rule
manual_title = GNU Time

# Use the direct link.  This is guaranteed to work immediately, while
# it can take a while for the faster mirror links to become usable.
url_dir_list = https://ftp.gnu.org/gnu/$(PACKAGE)

# Tools used to bootstrap this package, used for "announcement".
bootstrap-tools = autoconf,automake,gnulib

# Write cksum supported checksums into the announcement.
# I.e., base64 to reduce space, and possibly tagged to ease usage.
announce_gen_args = --cksum-checksums

old_NEWS_hash = 3702ab788541f5a222d97219516b5096

export VERBOSE = yes

update-copyright-env = \
  UPDATE_COPYRIGHT_USE_INTERVALS=1 \
  UPDATE_COPYRIGHT_MAX_LINE_LENGTH=79

local-checks-to-skip = \
  sc_bindtextdomain \
  sc_indent \
  sc_unmarked_diagnostics

exclude_file_name_regexp--sc_require_config_h_first = ^tests/time-aux\.c$
exclude_file_name_regexp--sc_require_config_h = \
  $(exclude_file_name_regexp--sc_require_config_h_first)

codespell_ignore_words_list = resuse,Ooutputs
