#!/usr/bin/env sh

# install tools
which mint 1>/dev/null || brew install mint
which pod 1>/dev/null || brew install cocoapods

# setup project
mint bootstrap
mint run xcodegen

if which rbenv 1>/dev/null; then
  rbenv exec gem install bundler
  rbenv exec bundler install
  rbenv exec bundler exec generamba template install
fi
