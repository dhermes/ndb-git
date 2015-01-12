#!/bin/bash

set -ev

ls cache
if [[ -d cache ]]; then
  echo "Cache exists. Current contents:"
  ls -1F cache
else
  echo "Making cache directory."
  mkdir cache
fi

cd cache

if [[ -f google_appengine_1.9.17.zip ]] && [[ -d google_appengine ]]; then
  echo "App Engine SDK already downloaded and unzipped. Doing nothing."
else
  wget https://storage.googleapis.com/appengine-sdks/featured/google_appengine_1.9.17.zip -nv
  unzip -q google_appengine_1.9.17.zip
fi
