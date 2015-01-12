#!/bin/bash

set -ev

[[ -d ${HOME}/cache ]] || mkdir ${HOME}/cache
cd ${HOME}/cache

if [[ ! -f google_appengine_1.9.17.zip ]]; then
  wget https://storage.googleapis.com/appengine-sdks/featured/google_appengine_1.9.17.zip -nv
fi
unzip -q google_appengine_1.9.17.zip
mv google_appengine/ ..
