function test_usage() (
  ./sensu-shell-helper -h 2>&1 | grep -q 'usage: ./sensu-shell-helper'
)

function test_bad_option() (
  ./sensu-shell-helper -BAD 2>&1 | grep -q 'illegal option'
)

function test_with_default_args_in_a_simple_case() (
EXPECTED='{"name": "_bin_true","output": "","status": 0}'
ACTUAL=$(./sensu-shell-helper -d /bin/true 2>&1)
if ! [[ "$ACTUAL" == "$EXPECTED" ]]; then
  echo "Actual output:"
  echo "$ACTUAL"
  echo "Didn't match what we expected:"
  echo "$EXPECTED"
  return 1
fi
)

function test_failing_output() (
EXPECTED='{"name": "_bin_false","output": "","status": 2}'
ACTUAL=$(./sensu-shell-helper -d /bin/false 2>&1)
if ! [[ "$ACTUAL" == "$EXPECTED" ]]; then
  echo "Actual output:"
  echo "$ACTUAL"
  echo "Didn't match what we expected:"
  echo "$EXPECTED"
  return 1
fi
)

function test_with_output() (
EXPECTED='{"name": "_bin_echo_test","output": "test","status": 0}'
ACTUAL=$(./sensu-shell-helper -d /bin/echo test 2>&1)
if ! [[ "$ACTUAL" == "$EXPECTED" ]]; then
  echo "Actual output:"
  echo "$ACTUAL"
  echo "Didn't match what we expected:"
  echo "$EXPECTED"
  return 1
fi
)

function test_with_output_escape_double_quotes() (
EXPECTED='{"name": "_bin_echo_test__double_quotes_","output": "test \"double quotes\"","status": 0}'
ACTUAL=$(./sensu-shell-helper -d /bin/echo 'test "double quotes"' 2>&1)
if ! [[ "$ACTUAL" == "$EXPECTED" ]]; then
  echo "Actual output:"
  echo "$ACTUAL"
  echo "Didn't match what we expected:"
  echo "$EXPECTED"
  return 1
fi
)

function test_with_output_escape_backslash() (
EXPECTED='{"name": "_bin_echo_test___backslash","output": "test \\ backslash","status": 0}'
ACTUAL=$(./sensu-shell-helper -d /bin/echo 'test \ backslash' 2>&1)
if ! [[ "$ACTUAL" == "$EXPECTED" ]]; then
  echo "Actual output:"
  echo "$ACTUAL"
  echo "Didn't match what we expected:"
  echo "$EXPECTED"
  return 1
fi
)

function test_with_hyphens() (
EXPECTED='{"name": "_bin_echo_test","output": "test","status": 0}'
ACTUAL=$(./sensu-shell-helper -d -- /bin/echo test 2>&1)
if ! [[ "$ACTUAL" == "$EXPECTED" ]]; then
  echo "Actual output:"
  echo "$ACTUAL"
  echo "Didn't match what we expected:"
  echo "$EXPECTED"
  return 1
fi
)

function test_with_handlers() (
EXPECTED='{"name": "_bin_echo_test","output": "test","handlers": ["email", "pagerduty"],"status": 0}'
ACTUAL=`./sensu-shell-helper -d -H '["email", "pagerduty"]' -- /bin/echo test 2>&1`
if ! [[ "$ACTUAL" == "$EXPECTED" ]]; then
  echo "Actual output:"
  echo "$ACTUAL"
  echo "Didn't match what we expected:"
  echo "$EXPECTED"
  return 1
fi
)

function test_alternate_name() (
EXPECTED='{"name": "Name_Override","output": "","status": 0}'
ACTUAL=`./sensu-shell-helper -d -n "Name Override"  /bin/true 2>&1`
if ! [[ "$ACTUAL" == "$EXPECTED" ]]; then
  echo "Actual output:"
  echo "$ACTUAL"
  echo "Didn't match what we expected:"
  echo "$EXPECTED"
  return 1
fi
)

function test_with_extra_JSON() (
EXPECTED='{"name": "_bin_echo_test","output": "test","metric": false"status": 0}'
ACTUAL=`./sensu-shell-helper -d -j '"metric": false' -- /bin/echo test 2>&1`
if ! [[ "$ACTUAL" == "$EXPECTED" ]]; then
  echo "Actual output:"
  echo "$ACTUAL"
  echo "Didn't match what we expected:"
  echo "$EXPECTED"
  return 1
fi
)

function test_multilines() (
EXPECTED='{"name": "_usr_bin_seq_1_5","output": "3 4 5","status": 0}'
ACTUAL=`./sensu-shell-helper -d /usr/bin/seq 1 5 2>&1`
if ! [[ "$ACTUAL" == "$EXPECTED" ]]; then
  echo "Actual output:"
  echo "$ACTUAL"
  echo "Didn't match what we expected:"
  echo "$EXPECTED"
  return 1
fi
)

function test_10_multilines() (
EXPECTED='{"name": "_usr_bin_seq_1_100","output": "96 97 98 99 100","status": 0}'
ACTUAL=`./sensu-shell-helper -d -c 5 /usr/bin/seq 1 100 2>&1`
if ! [[ "$ACTUAL" == "$EXPECTED" ]]; then
  echo "Actual output:"
  echo "$ACTUAL"
  echo "Didn't match what we expected:"
  echo "$EXPECTED"
  return 1
fi
)

function test_non_nagios_compliant() (
EXPECTED='{"name": "exit_42","output": "","status": 2}'
ACTUAL=`./sensu-shell-helper -d -- exit 42 2>&1`
if ! [[ "$ACTUAL" == "$EXPECTED" ]]; then
  echo "Actual output:"
  echo "$ACTUAL"
  echo "Didn't match what we expected:"
  echo "$EXPECTED"
  return 1
fi
)

function test_nagios_compliant() (
EXPECTED='{"name": "exit_42","output": "","status": 42}'
ACTUAL=`./sensu-shell-helper -N -d -- exit 42 2>&1`
if ! [[ "$ACTUAL" == "$EXPECTED" ]]; then
  echo "Actual output:"
  echo "$ACTUAL"
  echo "Didn't match what we expected:"
  echo "$EXPECTED"
  return 1
fi
)

