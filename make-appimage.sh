#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION="$(cat ~/version)"

export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON="https://raw.githubusercontent.com/CollaboraOnline/online/refs/heads/distro/collabora/coda-$VERSION/windows/coda/Assets/logo.png"
export OUTNAME=CODA-"$VERSION"-anylinux-"$ARCH".AppImage
#export DESKTOP=PATH_OR_URL_TO_DESKTOP_ENTRY
export DEPLOY_QT=1

# Deploy dependencies
quick-sharun /usr/bin/coda-qt \
    /usr/share/coda-qt \
    /usr/share/coolwsd

# Turn AppDir into AppImage
quick-sharun --make-appimage
