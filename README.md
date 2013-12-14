# Sensu-shell-helper
[![Build Status](https://travis-ci.org/solarkennedy/sensu-shell-helper.png)](https://travis-ci.org/solarkennedy/sensu-shell-helper)

## Description

Takes the output of a command and reports it to sensu. Makes it pretty trivial
add health checks to arbitary shell commands. Particularly good for cron jobs!

## Usage

    usage: sensu-shell-helper [OPTIONS] [--] COMMAND

## Options

    -h      Show help
    -n      Specify the name of the check. Defaults to the name of the command you run.
    -l      Send the output of the command to logger as well as Sensu with a provided tag.
    -d      Dry run, send the output what would be sent to Sensu to stderr.
    -H      String of an array of handlers. Defaults to empty. (use default handlers)
    -j      Specify custom json to cover a need that I can't think of. (see examples)
    -c      Count of the numer of lines to output ot sensu. Default: 3

## Examples:

    sensu-shell-helper /bin/false
    (reports the output to sensu sliently, with a name of /bin/false)

    sensu-shell-helper -l dailycron -n "Daily Apt Get Cron" /usr/bin/apt-get update
    (Get a sensu alert when your daily apt-get cron job fails, and get logs to syslog)

    sensu-shell-helper -H "['email', 'pagerduty']" -- /usr/bin/my_critical_command
    (Be explicity about handlers to use. Optional -- to separate the command)

    sensu-shell-helper -n "Special Check" -j '"playbook": "http://wiki/special_check", "metric: false",' -- /usr/bin/special_check
    (For when you need extra json in the output. NOTE: INCLUDE A TRAILING COMMA. Use -d for debug)

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
                 
