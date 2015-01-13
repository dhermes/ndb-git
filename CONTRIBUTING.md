Contributing
============================

- **Please sign one of the contributor license agreements below.**
- Fork the repo, develop and test your code changes, add docs.
- Make sure that your commit messages clearly describe the changes.
- Send a pull request.

Here are some guidelines for hacking on `ndb`.

Using a Development Checkout
----------------------------

You'll have to create a development environment to hack on `ndb`,
using a Git checkout:

-   While logged into your GitHub account, navigate to the `ndb` repo on
    GitHub.

    ```
    https://github.com/dhermes/ndb-git/
    ```

-   Fork and clone the `ndb` repository to your GitHub account by
    clicking the "Fork" button.

-   Clone your fork of `ndb` from your GitHub account to your local
    computer, substituting your account username and specifying the destination
    as `hack-on-ndb`. For example:

    ```
    $ cd ~
    $ git clone git@github.com:USERNAME/ndb-git.git hack-on-ndb
    $ cd hack-on-ndb
    # Configure remotes such that you can pull changes from the ndb-git
    # repository into your local repository.
    $ git remote add upstream https://github.com:dhermes/ndb-git
    # fetch and merge changes from upstream into master
    $ git fetch upstream
    $ git merge upstream/master
    ```

    Now your local repo is set up such that you will push changes to your GitHub
    repo, from which you can submit a pull request.

-   Create a virtualenv in which to install `ndb`:

    ```
    $ cd ~/hack-on-ndb
    $ virtualenv -ppython2.7 env
    ```

    Note that very old versions of `virtualenv` (versions below, say,
    1.10 or thereabouts) require you to pass a `--no-site-packages` flag to
    get a completely isolated environment.

    You can choose which Python version you want to use by passing a `-p`
    flag to `virtualenv`.  For example, `virtualenv -ppython2.7`
    chooses the Python 2.7 interpreter to be installed.

    From here on in within these instructions, the `~/hack-on-ndb/env`
    virtual environment you created above will be referred to as `${VENV}`.
    To use the instructions in the steps that follow literally, use the

    ```
    $ export VENV=~/hack-on-ndb/env
    ```

    command.

-   Install `ndb` from the checkout into the virtualenv using
    `setup.py develop`. Running `setup.py develop` **must** be done while
    the current working directory is the `ndb-git` checkout directory:

    ```
    $ cd ~/hack-on-ndb
    $ ${VENV}/bin/python setup.py develop
    ```

Running Tests
--------------

-   To run all tests for `ndb`, run

    ```
    $ tox -e py27
    ```

    or

    ```
    $ GAE=${PATH_TO_GAE_SDK} tox -e py27
    ```

    where the environment variable `GAE` is the path to to Google App
    Engine SDK.

-   In order to install the App Engine SDK for Python, you can either
    [download][1] the source as a zip file.

    If you already have the [Google Cloud SDK][2] (`gcloud` CLI tool)
    installed, then you can install via:

    ```
    $ gcloud components update gae-python
    ```

    If the Google Cloud SDK installed in `${GOOGLE_CLOUD_SDK}`,
    then the App Engine SDK can be found in
    `${GOOGLE_CLOUD_SDK}/platform/google_appengine` (as of January 2014).

    You can export this path as the `${GAE}` environment variable and
    then tests can be run simply as `tox -e py27`.

-   To see test coverage, run

    ```
    tox -e cover
    ```

    where as above `GAE` should be set.

Contributor License Agreements
------------------------------

Before we can accept your pull requests you'll need to sign a Contributor
License Agreement (CLA):

- **If you are an individual writing original source code** and **you own the
  intellectual property**, then you'll need to sign an [individual CLA][3].
- **If you work for a company that wants to allow you to contribute your work**,
  then you'll need to sign a [corporate CLA][4].

You can sign these electronically (just scroll to the bottom). After that,
we'll be able to accept your pull requests.

[1]: https://cloud.google.com/appengine/downloads
[2]: https://cloud.google.com/sdk/
[3]: https://developers.google.com/open-source/cla/individual
[4]: https://developers.google.com/open-source/cla/corporate
