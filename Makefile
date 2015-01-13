# Convenience to run tests and coverage.

# You must have installed the App Engine SDK toolkit in
# /usr/local/google_appengine.  For the required version see README.

# For Windows users, the "make.cmd" script has similar functionality.

FLAGS=
export GAE?=	/usr/local/google_appengine
NONTESTS=`find ndb -name [a-z]\*.py ! -name \*_test.py`
PYTHON= python -Wignore
COVERAGE=coverage
APPCFG= $(GAE)/../../bin/appcfg.py
DEV_APPSERVER=$(GAE)/../../bin/dev_appserver.py
DATASTORE_PATH=/tmp/ndb-dev_appserver.datastore
PORT=	8080
HOST=	localhost

help:
	@echo 'Makefile for NDB for Google App Engine                          '
	@echo '                                                                '
	@echo 'Usage:                                                          '
	@echo '   make runtests             Run all unit tests                 '
	@echo '   make coverage             Report test coverage               '
	@echo '   make serve                Serve sample app locally           '
	@echo '   make deploy               Deploy sample app                  '
	@echo '   make bench                Task creation benchmark            '
	@echo '   make key_bench            Key comparison benchmark           '
	@echo '   make put_bench            Multi-Put benchmark                '
	@echo '   make db_keys_only_bench   Key fetch benchmark using db       '
	@echo '   make ndb_keys_only_bench  Key fetch benchmark using ndb      '
	@echo '   make repl                 Custom REPL with NDB loaded        '
	@echo '   make gql                  Custom REPL for executing GQL      '
	@echo '   make longlines            Check long lines in source         '
	@echo '   make trimwhitespace       Trim trailing whitespace in source '
	@echo '   make get_tasklet_race     Test race conditions in get_tasklet'
	@echo '   make stress               Threadsafe Py27 Stress Test        '
	@echo '   make race                 Race condition tests for NDB       '
	@echo '   make multithread_test     Multi-threading torture test       '
	@echo '                                                                '
	@echo 'NOTE: This file is being wound down and will be fully           '
	@echo '      replaced by tox.ini.                                      '

runtests ndb_test:
	PYTHONPATH=. $(PYTHON) ndb/ndb_test.py $(FLAGS)

c cov cove cover coverage:
	PYTHONPATH=. $(COVERAGE) run ndb/ndb_test.py $(FLAGS)
	$(COVERAGE) html $(NONTESTS)
	$(COVERAGE) report -m $(NONTESTS)
	echo "open file://`pwd`/htmlcov/index.html"

serve:
	$(PYTHON) $(DEV_APPSERVER) demo/ --port $(PORT) --host $(HOST) $(FLAGS) --datastore_path=$(DATASTORE_PATH)

deploy:
	$(PYTHON) $(APPCFG) update demo/ --application=$(APP_ID) --version=$(APP_VERSION) $(FLAGS)

bench:
	PYTHONPATH=. $(PYTHON) benchmarks/bench.py $(FLAGS)

key_bench:
	PYTHONPATH=. $(PYTHON) benchmarks/key_bench.py $(FLAGS)

put_bench:
	PYTHONPATH=. $(PYTHON) benchmarks/put_bench.py $(FLAGS)

db_keys_only_bench:
	PYTHONPATH=. $(PYTHON) benchmarks/db_keys_only_bench.py $(FLAGS)

ndb_keys_only_bench:
	PYTHONPATH=. $(PYTHON) benchmarks/ndb_keys_only_bench.py $(FLAGS)

repl:
	PYTHONPATH=. $(PYTHON) -i development_tools/ndb_repl.py $(FLAGS)

gql:
	PYTHONPATH=. $(PYTHON) development_tools/gql_repl.py $(FLAGS)

longlines:
	$(PYTHON) longlines.py

tr trim trimwhitespace:
	$(PYTHON) trimwhitespace.py

g get_tasklet_race:
	PYTHONPATH=. $(PYTHON) benchmarks/get_tasklet_race.py $(FLAGS)

s stress:
	PYTHONPATH=. $(PYTHON) benchmarks/stress.py $(FLAGS)

race:
	PYTHONPATH=. $(PYTHON) benchmarks/race.py $(FLAGS)

multithread_test:
	PYTHONPATH=. $(PYTHON) benchmarks/multithread_test.py $(FLAGS)

.PHONY: help runtests coverage serve deploy bench key_bench put_bench db_keys_only_bench ndb_keys_only_bench repl gql longlines trimwhitespace get_tasklet_race stress race multithread_test
