#!/usr/bin/env sh

# install tools
which mint 1>/dev/null || brew install mint
which pod 1>/dev/null || brew install cocoapods

# setup project
mint bootstrap
mint run xcodegen
