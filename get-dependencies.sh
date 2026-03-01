#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    glu        \
    libdecor   \
    physfs     \
    python     \
    sdl2       \
    sdl2_image \
    sdl2_mixer

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
#make-aur-package dxx-rebirth-git

# If the application needs to be manually built that has to be done down here
echo "Making nightly build of D1X-Rebirth..."
echo "---------------------------------------------------------------"
REPO="https://github.com/dxx-rebirth/dxx-rebirth"
VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
git clone "$REPO" ./dxx-rebirth
echo "$VERSION" > ~/version

mkdir -p ./AppDir/bin
cd ./dxx-rebirth
wget https://www.dxx-rebirth.com/d1x-rebirth_addons.zip
bsdtar -xvf d1x-rebirth_addons.zip

local -a _common_opts=(
        "$MAKEFLAGS"
        '-Cdxx-rebirth'
        'builddir=./build'
        'prefix=/usr'
        'opengl=yes'
        'sdl2=yes'
        'sdlmixer=yes'
        'ipv6=yes'
        'use_udp=yes'
        'use_tracker=yes'
        'screenshot=png')
export CXXFLAGS="${CXXFLAGS/-Wp,-D_GLIBCXX_ASSERTIONS/}"
scons "${_common_opts[@]}" 'd1x=1' 'd2x=0'

mv -v build/d1x-rebirth/d1x-rebirth ./AppDir/bin
mv -v 'd1x-rebirth addons'/d1xr-hires.dxa ./AppDir/bin
mv -v 'd1x-rebirth addons'/"d1xr-sc55-music.dxa" ./AppDir/bin
mv -v d1x-rebirth/d1x-rebirth.desktop ./AppDir
cp contrib/packaging/linux/descent.svg ./AppDir/.DirIcon
mv -v contrib/packaging/linux/descent.svg ./AppDir
