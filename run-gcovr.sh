#!/bin/sh

set -eu

function readlink_f() {
  DIR=$(echo "${1%/*}")
  FILE=$(basename "$1")
  (cd "$DIR" && echo "$(pwd -P)/$FILE")
}

thisdir=$(dirname $(readlink_f "$0"))

gcovdir=$(mktemp -d -t gcovr)
tar -xzf "$thisdir/gcovr-3.0.tar.gz" -C "$gcovdir"
rootdir=$(pwd -P)
objdir=$(dirname $(grep -l "$rootdir" ~/Library/Developer/Xcode/DerivedData/*/info.plist))
(cd "$objdir" ; "$gcovdir/gcovr-3.0/scripts/gcovr" -x -r "$rootdir" $@) >coverage.xml
rm -r "$gcovdir"
