#!/bin/sh

set -eu

ARCH=$(uname -m)
#VERSION=$(pacman -Q dxx-rebirth-git | awk '{print $2; exit}') # example command to get version of application here
export ARCH #VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
#export ICON=https://raw.githubusercontent.com/dxx-rebirth/dxx-rebirth/refs/heads/master/contrib/packaging/linux/descent.svg
#export DESKTOP=/usr/share/applications/d1x-rebirth.desktop
export STARTUPWMCLASS=
export DEPLOY_OPENGL=1

# Deploy dependencies
quick-sharun ./AppDir/bin/d1x-rebirth

# Additional changes can be done in between here

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --test ./dist/*.AppImage
