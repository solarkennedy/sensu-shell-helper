#!/bin/bash

function file_of_function() (
    # Print the filename where the given function is defined.
    func="$1"
    shopt -s extdebug
    read func line file < <(declare -F "$func")
    echo "$file"
)

function discover_tests() {
    local file="$1"
    for test_func in $(compgen -A function test_ ); do
        if [[ "$(file_of_function "$test_func")" == "$file" ]]; then
            echo "$test_func"
        fi
    done;
}

function timeit() {
    # This function takes a command and its parameters.
    # It runs the command within the context of the `time`
    # bash keyword.
    # It redirects the stdout of the command it runs to
    # FD 3, and the stderr of that command to FD 4.

    command=("$@")
    (
        local TIMEFORMAT="%3R"
        time "${command[@]}" 1>&3 2>&4
    ) 2>&1
}

function repr() (
    local inargs=("$@")
    local outargs=()
    for arg in "${inargs[@]}"; do
        outarg=("$(declare -p arg)")
        outarg="${outarg##declare -- arg=}"
        outargs+=("$outarg")
    done
    echo "${outargs[@]}"
)

function assert() {
    if test "$@"; then
        return 0
    else
        retval="$?"
        echo "Assertion failed: $(repr "$@")" >&1
        return "$retval"
    fi
}

function run_tests() {
    # Run all the tests in a file. This requires sourcing the file.
    local file="$1"
    source "$file"
    test_funcs=($(discover_tests "$file"))
    # Redirect FDs 3 and 4 to stdout and stderr, respectively.
    # See timeit()
    exec 3>&1
    exec 4>&2
    successes=0
    failures=0
    for test_func in "${test_funcs[@]}"; do
        echo -n "$test_func ... "
        runtime="$(timeit "$test_func")"
        retval="$?"
        case "$retval" in
            0)  echo $'\e[32;1mOK\e[0m'
                ((successes++))
                ;;
            *)  echo $'\e[31;1mFAILURE\e[0m'": return code $retval"
                ((failures++))
                ;;
        esac
    done
    echo "${#test_funcs[@]} tests: $successes passed, $failures failed"
    return "$((failures > 0))"
}

function main() {
    run_tests "$1"
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    main "$@"
fi