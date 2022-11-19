#!/bin/bash -e

PLISTBUDDY="/usr/libexec/PlistBuddy"
URL="https://download.foldingathome.org/releases/public/release/fahcontrol/osx-10.11-64bit/v7.6/latest.pkg"

cd "$(dirname "$0")"
[ -d build ] && rm -r build
[ -d osx ] && rm -r osx

mkdir -p build/pkg-x/root

cd build

echo "Downloading $URL"
curl -fsSLO "$URL"
pkgutil --expand latest.pkg tmp
cd pkg-x/root
echo "Extracting payload"
cpio --quiet -i < ../../tmp/FAHControl.pkg/Payload

INFOPATH="./Applications/Folding@home/FAHControl.app/Contents/Info.plist"
VERSION=$("$PLISTBUDDY" -c "Print :CFBundleShortVersionString" "$INFOPATH")
TAG="(public release)"

cd ../../..

echo "Copying files"
mkdir -p osx/scripts
ditto build/tmp/Resources osx/Resources
ditto build/tmp/FAHControl.pkg/Scripts osx/scripts

echo -e "FAHControl $VERSION $TAG\n" > package-description.txt
F1="osx/Resources/en.lproj/Welcome.rtf"
if [ -f "$F1" ]; then
  textutil -stdout -convert txt "$F1" >> package-description.txt
  echo >> package-description.txt
fi

mv build/pkg-x build/pkg

echo "done"
