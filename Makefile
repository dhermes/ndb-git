# Convenience to run tests and coverage.

# You must have installed the App Engine SDK toolkit in
# /usr/local/google_appengine.  For the required version see README.

# For Windows users, the "make.cmd" script has similar functionality.

FLAGS=
PYTHON= python -Wignore

help:
	@echo 'Makefile for NDB for Google App Engine                          '
	@echo '                                                                '
	@echo 'Usage:                                                          '
	@echo '   make bench                Task creation benchmark            '
	@echo '   make key_bench            Key comparison benchmark           '
	@echo '   make put_bench            Multi-Put benchmark                '
	@echo '   make db_keys_only_bench   Key fetch benchmark using db       '
	@echo '   make ndb_keys_only_bench  Key fetch benchmark using ndb      '
	@echo '   make get_tasklet_race     Test race conditions in get_tasklet'
	@echo '   make stress               Threadsafe Py27 Stress Test        '
	@echo '   make race                 Race condition tests for NDB       '
	@echo '   make multithread_test     Multi-threading torture test       '
	@echo '   make repl                 Custom REPL with NDB loaded        '
	@echo '                                                                '
	@echo 'NOTE: This file is being wound down and will be fully           '
	@echo '      replaced by tox.ini.                                      '


bench:
	PYTHONPATH=. $(PYTHON) bench.py $(FLAGS)

key_bench:
	PYTHONPATH=. $(PYTHON) key_bench.py $(FLAGS)

put_bench:
	PYTHONPATH=. $(PYTHON) put_bench.py $(FLAGS)

db_keys_only_bench:
	PYTHONPATH=. $(PYTHON) db_keys_only_bench.py $(FLAGS)

ndb_keys_only_bench:
	PYTHONPATH=. $(PYTHON) ndb_keys_only_bench.py $(FLAGS)

get_tasklet_race:
	PYTHONPATH=. $(PYTHON) get_tasklet_race.py $(FLAGS)

stress:
	PYTHONPATH=. $(PYTHON) stress.py $(FLAGS)

race:
	PYTHONPATH=. $(PYTHON) race.py $(FLAGS)

multithread_test:
	PYTHONPATH=. $(PYTHON) multithread_test.py $(FLAGS)

repl:
	PYTHONPATH=$(GAEPATH):. $(PYTHON) -i ndb_repl.py $(FLAGS)

.PHONY: help bench key_bench put_bench db_keys_only_bench ndb_keys_only_bench get_tasklet_race stress race multithread_test repl
