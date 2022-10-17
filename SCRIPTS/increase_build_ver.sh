#!/bin/bash
set -e

# Find and increment the version number.
perl -i -pe 's/^(version:\s+\d+\.\d+\.\d+\+)(\d+)$/$1.($2+1)/e' client/pubspec.yaml

# Commit and tag this change.
version=`grep 'version: ' client/pubspec.yaml | sed 's/version: //'`
git commit -m "Bump version to $version" client/pubspec.yaml
git tag $version