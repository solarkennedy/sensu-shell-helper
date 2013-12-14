function test_usage() (
  ./sensu-shell-helper -h 2>&1 | grep -q 'usage: ./sensu-shell-helper'
)

function test_bad_option() (
  ./sensu-shell-helper -BAD 2>&1 | grep -q 'illegal option'
)

function test_with_default_args_in_a_simple_case() (
shouldbe="{
'name': '/bin/true',
'output': '', 
'status': '0'
}"
  [[ "$(./sensu-shell-helper -d /bin/true 2>&1)" == "$shouldbe" ]]
)

function test_failing_output() (
shouldbe="{
'name': '/bin/false',
'output': '', 
'status': '1'
}"
  [[ "$(./sensu-shell-helper -d /bin/false 2>&1)" == "$shouldbe" ]]
)

function test_with_output() (
shouldbe="{
'name': '/bin/echo',
'output': 'test', 
'status': '0'
}"
  [[ "$(./sensu-shell-helper -d /bin/echo test 2>&1)" == "$shouldbe" ]]
)


function test_with_hyphens() (
shouldbe="{
'name': '/bin/echo',
'output': 'test', 
'status': '0'
}"
  [[ "$(./sensu-shell-helper -d -- /bin/echo test 2>&1)" == "$shouldbe" ]]
)

function test_with_handlers() (
shouldbe="{
'name': '/bin/echo',
'output': 'test', 
'handlers': ['email', 'pagerduty'],
'status': '0'
}"
  RESULT=`./sensu-shell-helper -d -H "['email', 'pagerduty']" -- /bin/echo test 2>&1`
  [[ "$RESULT" == "$shouldbe" ]]
)

function test_alternate_name() (
shouldbe="{
'name': 'Name Override',
'output': '', 
'status': '0'
}"
  RESULT=`./sensu-shell-helper -d -n "Name Override"  /bin/true test 2>&1`
  [[ "$RESULT" == "$shouldbe" ]]
)

function test_with_extra_JSON() (
shouldbe="{
'name': '/bin/echo',
'output': 'test', 
'metric': false
'status': '0'
}"
  RESULT=`./sensu-shell-helper -d -j "'metric': false" -- /bin/echo test 2>&1`
  [[ "$RESULT" == "$shouldbe" ]]
)

function test_multilines() (
shouldbe="{
'name': '/usr/bin/seq',
'output': '3
4
5', 
'status': '0'
}"
  RESULT=`./sensu-shell-helper -d /usr/bin/seq 1 5 2>&1`
  [[ "$RESULT" == "$shouldbe" ]]
)

function test_10_multilines() (
shouldbe="{
'name': '/usr/bin/seq',
'output': '96
97
98
99
100', 
'status': '0'
}"
  RESULT=`./sensu-shell-helper -d -c 5 /usr/bin/seq 1 100 2>&1`
  [[ "$RESULT" == "$shouldbe" ]]
)

