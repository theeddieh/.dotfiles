#!/usr/bin/env bash
#
# redirect-reminder
#
# Because I always need to be reminded all the ways to redirect output.
#
# generically, its fd>&fd
# and the &> became a shorthand
#
# Inspired by:
#   * askubuntu.com/questions/350208/what-does-2-dev-null-mean
#   * unix.stackexchange.com/questions/163352/what-does-dev-null-21-mean-in-this-article-of-crontab-basics
#   * askubuntu.com/questions/983369/spaces-in-commands-with-redirection
#   * www.tldp.org/LDP/abs/html/io-redirection.html
#   * wiki.bash-hackers.org/howto/redirection_tutorial
#   * askubuntu.com/questions/1182450/what-does-2-mean-in-a-shell-script

# padding refresher
# right side
# printf ".%-16s.\n" "pad"
# left side
# printf ".%16s.\n" "pad"

format=" %-16s %2s\n"

printf "$format" \
"S Y N T A X     " "            M E A N I N G" \
"     > file"      "           stdout -> file" \
"    1> file"      "           stdout -> file" \
"    2> file"      "           stderr -> file" \
"    2>&fd"        "           stderr -> file descriptor" \
"  &fd> file"      "  file descriptor -> file" \
"     > file 2>&1" "           stdout -> file" \
"     .          " "                  and " \
"     .          " "           stderr -> stdout (legacy bash)" \
"    &> file"      "stdout and stderr -> file   (bash 4.0 and later)"

