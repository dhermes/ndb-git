# Convenience to run tests and coverage.

# You must have installed the App Engine SDK toolkit in
# /usr/local/google_appengine.  For the required version see README.

# For Windows users, the "make.cmd" script has similar functionality.

FLAGS=
PYTHON= python -Wignore

help:
	@echo 'Makefile for NDB for Google App Engine                       '
	@echo '                                                             '
	@echo 'Usage:                                                       '
	@echo '   make bench             Task creation benchmark            '
	@echo '   make keybench          Key comparison benchmark           '
	@echo '   make gettaskletrace    Test race conditions in get_tasklet'
	@echo '   make stress            Threadsafe Py27 Stress Test        '
	@echo '   make race              Race condition tests for NDB       '
	@echo '   make multithread_test  Multi-threading torture test       '
	@echo '   make repl              Custom REPL with NDB loaded        '
	@echo '                                                             '
	@echo 'NOTE: This file is being wound down and will be fully        '
	@echo '      replaced by tox.ini.                                   '


bench:
	PYTHONPATH=. $(PYTHON) bench.py $(FLAGS)

keybench:
	PYTHONPATH=. $(PYTHON) keybench.py $(FLAGS)

gettaskletrace:
	PYTHONPATH=. $(PYTHON) gettaskletrace.py $(FLAGS)

stress:
	PYTHONPATH=. $(PYTHON) stress.py $(FLAGS)

race:
	PYTHONPATH=. $(PYTHON) race.py $(FLAGS)

multithread_test:
	PYTHONPATH=. $(PYTHON) multithread_test.py $(FLAGS)

repl:
	PYTHONPATH=$(GAEPATH):. $(PYTHON) -i ndb_repl.py $(FLAGS)

.PHONY: help bench keybench gettaskletrace stress race multithread_test repl
