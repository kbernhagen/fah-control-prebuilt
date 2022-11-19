#!/bin/bash -e

cd "$(dirname "$0")"
[ -d build ] && rm -r build
[ -d osx ] && rm -r osx
[ -f package-description.txt ] && rm package-description.txt
