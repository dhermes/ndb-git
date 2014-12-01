This is a `git` port of [`appengine-ndb-experiment`][2] (a Mercurial
project). This was imported via

```
hg clone https://code.google.com/p/appengine-ndb-experiment/
# Checked out with tip at 1353:17ae1ecdc5b5
git clone git://repo.or.cz/fast-export.git
mkdir ndb-git && cd ndb-git
../fast-export/hg-fast-export.sh -r ../appengine-ndb-experiment/ --force
```

Note the use of `--force` flag. This was due to an error:
```
Error: repository has at least one unnamed head: hg r1337
```

The repository has 6 heads:
```
$ hg heads
changeset:   1353:17ae1ecdc5b5
tag:         tip
...
changeset:   1344:a430f38427b5
branch:      sandbox2
...
changeset:   1337:bbc44fd8eb16
...
changeset:   1255:bde0c1ced129
branch:      sandbox3
...
changeset:   1211:7de90cb76ece
branch:      sandbox
...
changeset:   1210:2cd433a67f77
branch:      r102
...
```
and indeed `1337` is not attached to a branch.

To deal with that, the following branch was created:
```
git branch bbc44fd8eb16 1f353fa384a87dcd18290b11df80041f0582f867
git checkout bbc44fd8eb16
git push origin bbc44fd8eb16
```

I also verified all the commits listed in `.git/hg2git-marks`
have been pushed in at least one of the remote branches:
```
$ git branch --remote
  origin/bbc44fd8eb16
  origin/drop-core
  origin/master
  origin/questionable-speedup
  origin/r102
  origin/sandbox
  origin/sandbox2
  origin/sandbox3
  origin/structured-orphans
```

Original Introduction
---------------------

(UPDATE: As of SDK 1.6.4, NDB has reached status General Availability.
Mentions of its experimental status in this file should be ignored.)

In this project I am developing a new, experimental datastore
API for the Google App Engine Python runtime. I am doing this as a
Google employee but using an open source development style as I
believe this project will benefit from early user feedback.

Eventually, when the project is sufficiently mature, the code will
(hopefully) become a standard component of the App Engine Python SDK
and the Python runtime. Until then, however, the way to use this code
is to check it out from the repository and copy it into your
application.

Until the code is integrated into the SDK and runtime, I am not going
to worry about backwards compatibility between versions of this
experimental code. You are not required to check out the trunk,
however I do not plan to fix bugs in older branches.

See the file LICENSE for the open source licensing conditions (which
are the same as for the App Engine SDK).

--Guido van Rossum <guido@google.com>


Overview
--------

The code is structured into two subdirectories:

- `ndb`: This is the main code base.  Notable submodules are
  `key.py`, `model.py`, `query.py`, `eventloop.py`, `tasklets.py`, and
  `context.py`. For each module `foo.py` there's a corresponding `foo_test.py`
  which contains unit tests for that module.

- `demo`: This is where demo programs live.  Check out `guestbook.py` and
  `main.py`.

The main directory contains some scripts and auxiliary files.

How To
------

You need to separately download and install the latest version of the
App Engine Python SDK.  NOTE: older versions don't work!!!!!!!!!
(If you don't know where to find that you are not ready to play with
this code. :-) Assuming the SDK lives at `/usr/local/google_appengine`,
you need to add that directory to your `$PYTHONPATH` environment
variable.  You should then be able to run something like this:

```python
>>> import ndb
```

If this works your setup is correct.

To run the tests, use

```
make
```

To run the tests with coverage, install the `coverage.py` [package][1]
and then use

```
make coverage
```

To run the demo app on `localhost:8080`, use

```
make serve
```

To run an interactive shell with `ndb` already imported and some sample
classes defined, use

```
make python
```

See the `Makefile` for more details.  For Windows users, the `make.cmd`
script has similar functionality.

[1]: http://nedbatchelder.com/code/coverage/
[2]: https://code.google.com/p/appengine-ndb-experiment/
