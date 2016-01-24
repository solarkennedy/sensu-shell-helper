# DEPRECATION NOTICE

This script is deprecated in favor of
[This Ruby-based replacement](https://github.com/jaxxstorm/sensu-wrapper)!!

# Sensu-shell-helper
[![Build Status](https://travis-ci.org/solarkennedy/sensu-shell-helper.png)](https://travis-ci.org/solarkennedy/sensu-shell-helper)

## Description

Takes the output of a command and reports it to Sensu. Makes it pretty trivial
add health checks to arbitrary shell commands. Particularly good for cron jobs!

By default raises 2 (Critical) on any non-0 exit code from the command.

## Usage

    usage: sensu-shell-helper [OPTIONS] [--] COMMAND

## Options

    -h      Show help
    -n      Specify the name of the check. Defaults to the name of the command you run with args,
            with non-compliant characters replaced with underscores.
    -l      Send the output of the command to logger as well as Sensu with a provided tag.
    -d      Dry run, send the output what would be sent to Sensu to stderr.
    -H      String of an array of handlers. Defaults to empty. (use default handlers)
    -j      Specify custom json to cover a need that I can't think of. (see examples)
    -c      Count of the number of lines to output to Sensu. Default: 3
    -N      Nagios Compliant. Use when the COMMAND returns 0,1,2,3 appropriately.

## Examples

    sensu-shell-helper /bin/false
    (reports the output to sensu sliently, with a name of /bin/false)

    sensu-shell-helper -l dailycron -n "Daily Apt Get Cron" /usr/bin/apt-get update
    (Get a sensu alert when your daily apt-get cron job fails, and send output to syslog)

    sensu-shell-helper -H '["email", "pagerduty"]' -- /usr/bin/my_critical_command
    (Be explicity about handlers to use. Optional -- to separate the command)

    sensu-shell-helper -n "Special Check" -j '"playbook": "http://wiki/special_check", "metric: false",' -- /usr/bin/special_check
    (For when you need extra json in the output. NOTE: INCLUDE A TRAILING COMMA. Use -d for debug)

## Behind The Scenes

sensu-shell-helper sends JSON to the local sensu agent running on localhost:3030. 
For example a command like:

    /sensu-shell-helper /usr/bin/seq 1 5

Would result in a json of:

    {
      "name": "_usr_bin_seq_1_5",
      "output": "3
    4
    5', 
      "status": 0
    }

sent to localhost:3030. Use the -d (dry-run) flag to confirm your JSON output.

## Installation

Simply copy the file somewhere, or:

    make install PREFIX=/usr

## Testing
Uses the testing framework from [Evan Krall](https://github.com/EvanKrall/bash-present)
to test basic functionality.

## Support
Open an [issue](https://github.com/solarkennedy/sensu-shell-helper/issues) or
[fork](https://github.com/solarkennedy/sensu-shell-helper/fork) and open a
[Pull Request](https://github.com/solarkennedy/sensu-shell-helper/pulls)
                 
