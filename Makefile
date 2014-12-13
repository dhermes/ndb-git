# Convenience to run tests and coverage.

# You must have installed the App Engine SDK toolkit in
# /usr/local/google_appengine.  For the required version see README.

# For Windows users, the "make.cmd" script has similar functionality.

FLAGS=
GAE=/usr/local/google_appengine
GAEPATH=$(GAE):$(GAE)/lib/yaml/lib:$(GAE)/lib/webob:$(GAE)/lib/fancy_urllib:$(GAE)/lib/simplejson:$(GAE)/lib/protorpc:$(GAE)/lib/protorpc-1.0
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
	PYTHONPATH=$(GAEPATH):. $(PYTHON) ndb/ndb_test.py $(FLAGS)

c cov cove cover coverage:
	PYTHONPATH=$(GAEPATH):. $(COVERAGE) run ndb/ndb_test.py $(FLAGS)
	$(COVERAGE) html $(NONTESTS)
	$(COVERAGE) report -m $(NONTESTS)
	echo "open file://`pwd`/htmlcov/index.html"

bench:
	PYTHONPATH=$(GAEPATH):. $(PYTHON) bench.py $(FLAGS)

keybench:
	PYTHONPATH=$(GAEPATH):. $(PYTHON) keybench.py $(FLAGS)

g gettaskletrace:
	PYTHONPATH=$(GAEPATH):. $(PYTHON) gettaskletrace.py $(FLAGS)

s stress:
	PYTHONPATH=$(GAEPATH):. $(PYTHON) stress.py $(FLAGS)

race:
	PYTHONPATH=$(GAEPATH):. $(PYTHON) race.py $(FLAGS)

mttest:
	PYTHONPATH=$(GAEPATH):. $(PYTHON) mttest.py $(FLAGS)
