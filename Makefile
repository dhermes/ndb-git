# Convenience to run tests and coverage.

# You must have installed the App Engine SDK toolkit in
# /usr/local/google_appengine.  For the required version see README.

# For Windows users, the "make.cmd" script has similar functionality.

FLAGS=
export GAE?=/usr/local/google_appengine
TESTS=`find ndb -name [a-z]\*_test.py ! -name ndb_test.py`
NONTESTS=`find ndb -name [a-z]\*.py ! -name \*_test.py`
PORT=8080
ADDRESS=localhost
PYTHON= python -Wignore
APPCFG= $(GAE)/appcfg.py
DEV_APPSERVER=$(GAE)/dev_appserver.py
COVERAGE=coverage
DATASTORE_PATH=/tmp/ndb-dev_appserver.datastore

default: runtests

runtests ndb_test:
	PYTHONPATH=. $(PYTHON) ndb/ndb_test.py $(FLAGS)

c cov cove cover coverage:
	$(COVERAGE) run ndb/ndb_test.py $(FLAGS)
	$(COVERAGE) html $(NONTESTS)
	$(COVERAGE) report -m $(NONTESTS)
	echo "open file://`pwd`/htmlcov/index.html"

bench:
	PYTHONPATH=. $(PYTHON) bench.py $(FLAGS)

keybench:
	PYTHONPATH=. $(PYTHON) keybench.py $(FLAGS)

g gettaskletrace:
	PYTHONPATH=. $(PYTHON) gettaskletrace.py $(FLAGS)

s stress:
	PYTHONPATH=. $(PYTHON) stress.py $(FLAGS)

race:
	PYTHONPATH=. $(PYTHON) race.py $(FLAGS)

multithread_test.py:
	PYTHONPATH=. $(PYTHON) multithread_test.py $(FLAGS)
