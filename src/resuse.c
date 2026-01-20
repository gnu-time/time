/* resuse.c - child process resource use library
   Copyright (C) 1993-2021, 2026 Free Software Foundation, Inc.

   Written by David MacKenzie, with help from
   arnej@imf.unit.no (Arne Henrik Juul)
   and pinard@iro.umontreal.ca (Francois Pinard).

   This file is part of GNU Time.

   GNU Time is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   GNU Time is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with GNU Time.  If not, see <http://www.gnu.org/licenses/>.
*/

#include <config.h>
#include <sys/time.h>
#include <sys/wait.h>
#include <sys/resource.h>

#include "timespec.h"

#include "resuse.h"

/* Prepare to measure a child process.  */

void
resuse_start (RESUSE *resp)
{
  resp->start_time = current_timespec ();
}

/* Wait for and fill in data on child process PID.
   Return 0 on error, 1 if ok.  */

int
resuse_end (pid_t pid, RESUSE *resp)
{
  int status;

  /* Wait for the child process and get its resource usage.  */
  if (waitpid (pid, &status, 0) < 0
      || getrusage (RUSAGE_CHILDREN, &resp->ru) < 0)
    return 0;

  resp->end_time = current_timespec ();

  resp->waitstatus = status;

  return 1;
}
