#!/usr/bin/env bash
#
# refresher_ps.sh
#
# Simpler wrapper that holds common used flags for that I alway seem to need to look up. 
# Right now it just has flags for ps
#
# Usage:
#       refresher <cmd> 
# 

#     -A      Display information about other users' processes, including those without controlling terminals.
#     -a      Display information about other users' processes as well as your own.  This will skip any processes which do not have a controlling terminal, unless the
#             -x option is also specified.
#     -c      Change the ``command'' column output to just contain the executable name, rather than the full command line.
#     -d      Like -A, but excludes session leaders.
#     -e      Identical to -A.
#     -f      Display the uid, pid, parent pid, recent CPU usage, process start time, controlling tty, elapsed CPU usage, and the associated command.  If the -u option
#             is also used, display the user name rather then the numeric uid.  When -o or -O is used to add to the display following -f, the command field is not
#             truncated as severely as it is in other formats.
#     -u      Display the processes belonging to the specified usernames.
#     -X      When displaying processes matched by other options, skip any processes which do not have a controlling terminal.
#     -x      When displaying processes matched by other options, include processes which do not have a controlling terminal.  This is the opposite of the -X option.

- ps
    - your processes
    - w/ controlling terminal

| Flags / Effects | mine | others | incl proc w/o ctl term | full cmd line |
|              "" | [√]  | [x]    | [x]                    | [-]
|            "-A" | [x]  | [√]    | [√]                    | [-]
|            "-a" | [√]  | [√]    | [x]                    | [-]
|            "-c" | [-]  | [-]    | [-]                    | [x]
|              "" | [+]  | [ ]    | [ ]                    |
|              "" | [+]  | [ ]    | [ ]                    |
|              "" | [+]  | [ ]    | [ ]                    |
|              "" | [+]  | [ ]    | [ ]                    |

|           