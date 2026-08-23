#!/bin/sh

set -eu

ARCH=$(uname -m)
export ARCH
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=https://raw.githubusercontent.com/dxx-rebirth/dxx-rebirth/cb0473dbd5fb6e261223080ba1e60b6d7a228954/contrib/packaging/linux/descent.svg
export STARTUPWMCLASS=d1x-rebirth
export DEPLOY_OPENGL=1
export DEPLOY_PIPEWIRE=1

# Deploy dependencies
quick-sharun ./AppDir/bin/d1x-rebirth /usr/lib/libfluidsynth.so*

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --test ./dist/*.AppImage
