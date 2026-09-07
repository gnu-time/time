#!/bin/sh
# Test that errors are quoted appropriately.

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

# Test a non-existent program without characters that require
# escaping.
cat <<\EOF >exp || framework_failure_
time: './missing'
EOF
returns_ 127 env time ./missing >out 2>err-t || fail=1
head -n 1 err-t | cut -d: -f1-2 > err || framework_failure_
compare /dev/null out || fail=1
compare exp err || fail=1

# Test that the newline is escaped.
cat <<\EOF >exp || framework_failure_
time: './n\nl'
EOF
newline='n
l'
returns_ 127 env time ./"$newline" >out 2>err-t || fail=1
head -n 1 err-t | cut -d: -f1-2 > err || framework_failure_
compare /dev/null out || fail=1
compare exp err || fail=1

# Test a bad file name given to --output without characters
# that require escaping.
mkdir dir || framework_failure_
cat <<\EOF >exp || framework_failure_
time: dir
EOF
returns_ 125 env time -o dir true >out 2>err-t || fail=1
head -n 1 err-t | cut -d: -f1-2 > err || framework_failure_
compare /dev/null out || fail=1
compare exp err || fail=1

# Test that the newline is escaped.
mkdir -p "$newline" || framework_failure_
cat <<\EOF >exp || framework_failure_
time: 'n'$'\n''l'
EOF
returns_ 125 env time -o "$newline" true >out 2>err-t || fail=1
head -n 1 err-t | cut -d: -f1-2 > err || framework_failure_
compare /dev/null out || fail=1
compare exp err || fail=1

Exit $fail
