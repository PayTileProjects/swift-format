#!/bin/sh

set -e

# Can't build universal right away because of a dylib being copied twice
# Easy enough to build separately and lipo them together
swift build --configuration release --arch x86_64
swift build --configuration release --arch arm64

DEST=".build/apple/release"

mkdir -p $DEST

lipo \
  -create .build/arm64-apple-macosx/release/swift-format .build/x86_64-apple-macosx/release/swift-format \
  -output $DEST/swift-format

# The dylib is universal, so no need to fiddle with it
cp .build/arm64-apple-macosx/release/lib_InternalSwiftSyntaxParser.dylib $DEST

rm -f swift-format-darwin-universal.zip
zip -rj swift-format-darwin-universal.zip $DEST
