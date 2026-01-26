#!/bin/sh
# Test the $TIME environment variable.

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

# Test that the $TIME environment variable is used.
env TIME=%C time -o out true || fail=1
echo true > exp || framework_failure_
compare exp out || fail=1

# Test that --format (-f) has precedence over the $TIME environment variable.
env TIME=%C time -o out -f %x true || fail=1
echo 0 > exp || framework_failure_
compare exp out || fail=1

Exit $fail
