PREFIX = /usr/local

test:
	bash test_framework.sh sensu_helper_tests.sh

install:
	install -m 755 sensu-shell-helper $(PREFIX)/bin/sensu-shell-helper
