# Customize maint.mk                           -*- makefile -*-
# Copyright (C) 2018-2021 Free Software Foundation, Inc.

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

old_NEWS_hash = d41d8cd98f00b204e9800998ecf8427e

update-copyright-env = \
  UPDATE_COPYRIGHT_USE_INTERVALS=2 \
  UPDATE_COPYRIGHT_MAX_LINE_LENGTH=79

local-checks-to-skip = \
  sc_bindtextdomain \
  sc_unmarked_diagnostics

exclude_file_name_regexp--sc_require_config_h_first = ^tests/time-aux\.c$
exclude_file_name_regexp--sc_require_config_h = \
  $(exclude_file_name_regexp--sc_require_config_h_first)
