#!/bin/sh
# Test 'time' with the --verbose option.

# Copyright (C) 2026 Free Software Foundation, Inc.

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

. "${srcdir=.}/tests/init.sh"; path_prepend_ ./src

for opt in -v --verbose; do
  # Test that the --verbose (-v) option has precedence over the --format (-f)
  # option regardless of argument ordering.
  env time --format=a $opt -o out true || fail=1
  test $(wc -l < out) -eq 23 || fail=1
  env time $opt --format=a -o out true || fail=1
  test $(wc -l < out) -eq 23 || fail=1

  # Test that the --verbose (-v) option has precedence over $TIME environment
  # variable.
  env TIME=a time $opt -o out true || fail=1
  test $(wc -l < out) -eq 23 || fail=1
done

Exit $fail
