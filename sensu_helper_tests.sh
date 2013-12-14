function test_usage() (
  ./sensu-shell-helper -h 2>&1 | grep -q 'usage: ./sensu-shell-helper'
)
